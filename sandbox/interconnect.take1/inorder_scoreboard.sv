// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class inorder_scoreboard # (type REQ_T=axi_transaction, type RESP_T=ocp_transaction) extends uvm_scoreboard;
   `uvm_component_utils(inorder_scoreboard)

   uvm_analysis_export #(REQ_T) req_an_export;
   uvm_analysis_export #(RESP_T) resp_an_export;

   uvm_tlm_analysis_fifo #(REQ_T) REQ_FIFO;
   uvm_tlm_analysis_fifo #(RESP_T) RESP_FIFO;

   int master_id;

   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      req_an_export = new("req_an_export", this);
      resp_an_export = new("resp_an_export", this);

      REQ_FIFO = new("REQ_FIFO", this);
      RESP_FIFO = new("RESP_FIFO", this);      
   endfunction // build_phase   

   function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);      

      req_an_export.connect(REQ_FIFO.analysis_export);
      resp_an_export.connect(RESP_FIFO.analysis_export);      

   endfunction // connect_phase

   task run_phase (uvm_phase phase);
      REQ_T req_txn;
      RESP_T resp_txn;

      forever begin
	 REQ_FIFO.get(req_txn);
	 `uvm_info("run_phase", $psprintf("Got Req TX: %s", req_txn.convert2string()), UVM_MEDIUM)
	 RESP_FIFO.get(resp_txn);
	 `uvm_info("run_phase", $psprintf("Got Resp TX: %s", resp_txn.convert2string()), UVM_MEDIUM)	 
	 if (master_id == 0) begin
	    while (req_txn.id > 7) RESP_FIFO.get(resp_txn);
	 end	 
	 else if (master_id == 1) begin
	    while (req_txn.id < 7) RESP_FIFO.get(resp_txn);	    
	 end
	 compare_axi_ocp("Inorder Scoreboard", 0, req_txn, resp_txn);	 
      end
      
   endtask // run_phase

   task compare_axi_ocp(string msg = "Scoreboard", bit compare_data = 1, REQ_T req_txn, RESP_T resp_txn);
      int i;
      string status = "eq";
      axi_transaction axi_txn;
      ocp_transaction ocp_txn;

      axi_txn = new();
      ocp_txn = new();
      
      if ($cast(ocp_txn, req_txn)) begin end
      else if ($cast(ocp_txn, resp_txn)) begin end
      else begin `uvm_error("compare_axi_comp", "Casting of arguments to axi_txn failed") end

      if ((axi_txn.rw == AXI_READ  & ocp_txn.cmd != OCP_READ) ||
	  (axi_txn.rw == AXI_WRITE & ocp_txn.cmd != OCP_WRITE)) begin
	 status = "RD/WR";
      end
      else if (axi_txn.addr != ocp_txn.addr) begin
	 status = "ADDR";	 
      end
      else if (axi_txn.id != ocp_txn.id) begin
	 status = "ID";	 
      end
      else if (axi_txn.length == ocp_txn.length) begin
	 status = "LENGTH";	 
      end
      else if (compare_data) begin
	 for (int i = 0; i < axi_txn.length; ++i) begin
	    if (axi_txn.data[i] != ocp_txn.data[i]) begin
	       status = $psprintf("Data[%h]", i);	       
	       break;		 
	    end	    
	 end	 
      end

      if (status == "eq") begin
	 `uvm_info(msg, "SUCCESS: Transactions are equal", UVM_MEDIUM)
	 `uvm_info("compare_axi_ocp", axi_txn.convert2string(), UVM_MEDIUM)
	 `uvm_info("compare_axi_ocp", ocp_txn.convert2string(), UVM_MEDIUM)	 	 
      end else begin
	 `uvm_error(msg, $psprintf("ERROR :: Transactions are NOT equal. They start differing from %s", status))
	 `uvm_info("compare_axi_ocp", axi_txn.convert2string(), UVM_NONE)	 
	 `uvm_info("compare_axi_ocp", ocp_txn.convert2string(), UVM_NONE)	 
      end      

   endtask // compare_axi_ocp   
   
endclass // inorder_scoreboard

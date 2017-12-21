// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class inorder_scoreboard #(type REQ_T=axi_transaction, type RESP_T=ocp_transaction) extends uvm_scoreboard;
   `uvm_component_param_utils(inorder_scoreboard #(REQ_T, RESP_T))

   int master_id;   

   uvm_analysis_export #(REQ_T)  req_ana_export;
   uvm_analysis_export #(RESP_T) resp_ana_export;

   uvm_tlm_analysis_fifo #(REQ_T)  REQ_FIFO;
   uvm_tlm_analysis_fifo #(RESP_T) RESP_FIFO;

   function new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      REQ_FIFO  = new("REQ_FIFO", this);
      RESP_FIFO = new("RESP_FIFO", this);            

      req_ana_export = new("req_ana_export", this);
      resp_ana_export = new("resp_ana_export", this);
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      req_ana_export.connect(REQ_FIFO.analysis_export);
      resp_ana_export.connect(RESP_FIFO.analysis_export);      
   endfunction // connect_phase

   virtual task run_phase(uvm_phase phase);
      REQ_T req_txn;
      RESP_T resp_txn;

      req_txn = new();
      resp_txn = new();

      forever begin
	 REQ_FIFO.get(req_txn);
	 RESP_FIFO.get(resp_txn);

	 if (master_id == 1)
	   while (resp_txn.id > 7) RESP_FIFO.get(resp_txn);
	 else if (master_id == 2)
	   while (resp_txn.id < 8) RESP_FIFO.get(resp_txn);	 

	 compare_txn(req_txn, resp_txn);	 
      end      
   endtask // run_phase

   task compare_txn (REQ_T req_txn, RESP_T resp_txn);
      int i;      
      string status = "eq";
      
      if ( (req_txn.rw == READ && resp_txn.cmd != READ) ||
	   (req_txn.rw == WRITE && resp_txn.cmd != WRITE) )
	status = "RD/WR";
      else if (req_txn.id != resp_txn.id)
	status = "ID";
      else if (req_txn.addr != resp_txn.addr)
	status = "ADDR";
      else if (req_txn.length != resp_txn.length)
	status = "LENGTH";
      else begin
	 for (i=0; i<req_txn.length; ++i) begin
	    if (req_txn.data[i] != resp_txn.data[i])
	      status = "DATA";	    
	 end	 
      end

      if (status == "eq") 
	`uvm_info("msg", "SUCCESS", UVM_MEDIUM)
      else 
	`uvm_info("msg", "FAILURE", UVM_MEDIUM)

   endtask // compare_txn   
   
endclass // inorder_scoreboard




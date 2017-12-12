// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// ocp slave driver
//

class ocp_slave_driver extends uvm_driver #(ocp_transaction);
   `uvm_component_utils(ocp_slave_driver);

   // driver sub components: config, dut interface
   ocp_config ocp_cfg;
   virtual ocp_if ocp_vif;
   virtual clkrst_if clkrst_vif;   

   event e_new_input_req_received;
   ocp_transaction ocp_req_txn_q[$];
   ocp_transaction ocp_rsp_txn_q[$];   
   
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   // build_phase
   //   1. assign virtual interface
   
   function void build_phase (uvm_phase phase);
      super.build_phase(phase);      

      //   1. assign virtual interface
      ocp_vif = ocp_cfg.ocp_vif;
      clkrst_vif = ocp_cfg.clkrst_vif;      

   endfunction // build_phase

   // run_phase
   //   1. wait for reset
   //   2. fork off driver tasks
   
   task run_phase (uvm_phase phase);

      //   1. wait for 
      wait (!clkrst_vif.rstn);
      @(posedge clkrst_vif.rstn);      

      //   2. fork off driver tasks
      fork
	 manage_sequence_txn();
	 monitor_interface_req();
	 drive_interface_resp();	 
      join_none      

   endtask // run_phase

   task manage_sequence_txn();
      ocp_transaction ocp_txn;

      ocp_txn = new();
      
      seq_item_port.get_next_item(ocp_txn);
      `uvm_info("manage_sequence_txn", "Received OCP Transaction from sequencer", UVM_MEDIUM)
      wait (e_new_input_req_received.triggered)
      seq_item_port.item_done();      
   endtask // manage_sequence_txn

   task monitor_interface_req();
      int i;      
      ocp_transaction ocp_txn;

      ocp_txn = new();
      
      forever @(posedge clkrst_vif.clk) begin
	 if (ocp_vif.ocp_mCmd == OCP_WRITE) begin
	    ocp_txn.cmd    = OCP_WRITE;
	    ocp_txn.id     = ocp_vif.ocp_mTagId;
	    ocp_txn.addr   = ocp_vif.ocp_mAddr;
	    ocp_txn.length = ocp_vif.ocp_mBurstLength;
	    ocp_txn.data   = new[ocp_txn.length];	    

	    ocp_vif.ocp_sCmdAccept = 1;

	    i = 0;	    
	    while (!ocp_vif.ocp_mReqLast) begin
	       ocp_txn.data[i] = ocp_vif.ocp_mData;
	       @(posedge clkrst_vif.clk);	       
	       ++i;
	    end	    

	    ocp_vif.ocp_sCmdAccept = 0;
	    ocp_req_txn_q.push_back(ocp_txn);
	    
	    `uvm_info("monitor_interface_req", 
		      $psprintf("Received WR Transaction: id=%h Addr=%h", ocp_txn.id, ocp_txn.addr),
		      UVM_MEDIUM)	    
	    
	    -> e_new_input_req_received;
	 end
	 // dummy for now
	 else if (ocp_vif.ocp_mCmd == OCP_READ) begin
	 end	 	 
      end
            
   endtask // monitor_interface_req   

   task drive_interface_resp;
   endtask // drive_interface_resp
   
endclass // ocp_slave_driver


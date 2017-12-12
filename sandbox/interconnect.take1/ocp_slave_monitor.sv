// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// ocp slave monitor
//

class ocp_slave_monitor extends uvm_monitor;
   `uvm_component_utils(ocp_slave_monitor)

   // monitor sub components: config, dut interface
   ocp_config ocp_cfg;
   virtual ocp_if ocp_vif;   
   virtual clkrst_if clkrst_vif;   
   
   // monitor analysis port
   uvm_analysis_port #(ocp_transaction) ocp_wr_aport;
   uvm_analysis_port #(ocp_transaction) ocp_rd_aport;
   
   event e_ocp_req_received;   
   event e_ocp_rsp_generated;   
   ocp_transaction ocp_req_txn_q[$];
   ocp_transaction ocp_rsp_txn_q[$];   
     
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   // build_phase
   //   1. new analysis ports 
   //   2. assign virtual interface

   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);

      //   1. new analysis ports 
      ocp_wr_aport = new ("ocp_wr_aport", this);
      ocp_rd_aport = new ("ocp_rd_aport", this);
      
      //   2. assign virtual interface
      ocp_vif = ocp_cfg.ocp_vif;
      clkrst_vif = ocp_cfg.clkrst_vif;      
      
   endfunction // build_phase
   
   // run_phase
   //   1. wait for reset
   //   2. fork off monitor tasks
   
   task run_phase (uvm_phase phase);
      
      wait (!clkrst_vif.rstn);
      @(posedge clkrst_vif.rstn);      
      
      fork
	 monitor_input_req();
	 monitor_output_resp();	 
      join_none
      
   endtask // run_phase

   task monitor_input_req();
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

	    i = 0;	
	    while (!ocp_vif.ocp_mReqLast) begin
	       ocp_txn.data[i] = ocp_vif.ocp_mData;
	       @(posedge clkrst_vif.clk);	       
	       ++i;
	    end
	    ocp_wr_aport.write(ocp_txn);	    
	    `uvm_info("monitor_input_req", 
		      $psprintf("Sending OCP Wr Transaction to Txn aport: id=%h Addr=%h", ocp_txn.id, ocp_txn.addr),
		      UVM_MEDIUM)	    
	 end
	 // dummy for now
	 else if (ocp_vif.ocp_mCmd == OCP_READ) begin
	 end	 
      end
      
   endtask // monitor_input_req

   task monitor_output_resp();
   endtask // monitor_output_resp   
   
endclass // ocp_slave_monitor



// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// axi master driver
//

class axi_master_driver extends uvm_driver #(axi_transaction);
   `uvm_component_utils(axi_master_driver)

   // driver sub components: config, dut interface
   axi_config axi_cfg;
   virtual clkrst_if clkrst_vif;   
   virtual axi_waddr_if axi_waddr_vif;
   virtual axi_wdata_if axi_wdata_vif;
   virtual axi_wresp_if axi_wresp_vif;
   virtual axi_raddr_if axi_raddr_vif;
   virtual axi_rdata_if axi_rdata_vif;

   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   // build_phase
   //   1. retrive axi master driver config
   //   2. assign virtual interface
   
   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);      

      // 2. assign virtual interface
      clkrst_vif    = axi_cfg.clkrst_vif;      
      axi_waddr_vif = axi_cfg.axi_waddr_vif;
      axi_wdata_vif = axi_cfg.axi_wdata_vif;
      axi_wresp_vif = axi_cfg.axi_wresp_vif;
      axi_raddr_vif = axi_cfg.axi_raddr_vif;
      axi_rdata_vif = axi_cfg.axi_rdata_vif;
      
   endfunction // build_phase

   // run_phase - fork off driver tasks
   //   1. wait for reset de-asserted
   //   2. fork off run phase tasks
   
   virtual task run_phase (uvm_phase phase);

      //   1. wait for reset de-asserted
      wait (!clkrst_vif.rstn);
      @(posedge clkrst_vif.rstn);      

      //   2. fork off run phase tasks
      fork
	 manage_sequencer_txn();
	 drive_wr_resp_ready();
	 drive_rd_resp_ready();	
      join_none      

   endtask // run_phase

   task manage_sequencer_txn();
      axi_transaction axi_txn;

      axi_txn = new();
      
      seq_item_port.get_next_item(axi_txn);
      `uvm_info("drive_axi_wr_addr", "Debug 1 ... start driver", UVM_MEDIUM)      

      if (axi_txn.rw == WRITE) begin
	 fork
	    drive_axi_wr_addr(axi_txn);
	    drive_axi_wr_data(axi_txn);
	 join	 
      end
      else if (axi_txn.rw == READ) begin
	 drive_axi_rd_addr(axi_txn);	 
      end
      
      seq_item_port.item_done();      
   endtask // manage_sequencer_txn

   task drive_axi_wr_addr(axi_transaction axi_txn);
      wait (axi_waddr_vif.axi_awready) @(posedge clkrst_vif.clk);

      axi_waddr_vif.axi_awid    = axi_txn.id;
      axi_waddr_vif.axi_awlen   = axi_txn.length;
      axi_waddr_vif.axi_awaddr  = axi_txn.addr;
      axi_waddr_vif.axi_awvalid = 1;

      @(posedge clkrst_vif.clk);
      axi_waddr_vif.axi_awvalid = 0;

      `uvm_info("drive_axi_wr_addr", $psprintf("Send AXI Write Txn: id=%d addr=%d", axi_txn.id, axi_txn.addr), UVM_MEDIUM)
      
   endtask // drive_axi_wr_addr   

   task drive_axi_wr_data(axi_transaction axi_txn);

      for (int i=0; i < axi_txn.length; ++i) begin
	 wait (axi_wdata_vif.axi_wready) @(posedge clkrst_vif.clk);

	 axi_wdata_vif.axi_wvalid   = 1;
	 axi_wdata_vif.axi_wid      = axi_txn.id;
	 axi_wdata_vif.axi_wdata[i] = axi_txn.data[i];
	 axi_wdata_vif.axi_wlast    = (i == axi_txn.length-1) ? 1 : 0;	
	 `uvm_info("drive_axi_wr_data", $psprintf("Send AXI Write Data: id=%d data[0]=%d", axi_txn.id, i, axi_txn.data[0]), UVM_MEDIUM)
      end
      
      @(posedge clkrst_vif.clk);
      axi_wdata_vif.axi_wlast = 0;
      axi_wdata_vif.axi_wvalid = 0;

   endtask // drive_axi_wr_data   

   task drive_axi_wr_resp();
      forever @(posedge clkrst_vif.clk) begin
	 while (axi_wresp_vif.axi_bresp) begin
	    @(posedge clkrst_vif.clk);
	    axi_wresp_vif.axi_bvalid = 1;	    
	    @(posedge clkrst_vif.clk);
	    axi_wresp_vif.axi_bvalid = 0;	    
	 end	 
      end
      
   endtask // drive_axi_wr_resp

   // dummy for now (randomized with write)
   task drive_axi_rd_addr(axi_transaction axi_txn);
   endtask // drive_axi_rd_addr

   // dummy for now (randomized with write)
   task drive_axi_rd_resp();
   endtask // drive_axi_rd_resp   

   // dummy
   task drive_wr_resp_ready();
   endtask // drive_wr_resp_ready

   // dummy
   task drive_rd_resp_ready();
   endtask // drive_rd_resp_ready      
     
endclass // axi_master_driver


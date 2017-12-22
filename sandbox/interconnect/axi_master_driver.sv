// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_master_driver extends uvm_driver #(axi_transaction);   
   `uvm_component_utils(axi_master_driver)

   axi_config axi_cfg;

   virtual clk_rst_if clk_rst_vif;
   virtual axi_raddr_if axi_raddr_vif;
   virtual axi_rdata_if axi_rdata_vif;
   virtual axi_waddr_if axi_waddr_vif;
   virtual axi_wdata_if axi_wdata_vif;
   virtual axi_wresp_if axi_wresp_vif;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      clk_rst_vif = axi_cfg.clk_rst_vif;
      axi_raddr_vif = axi_cfg.axi_raddr_vif;
      axi_rdata_vif = axi_cfg.axi_rdata_vif;
      axi_waddr_vif = axi_cfg.axi_waddr_vif;
      axi_wdata_vif = axi_cfg.axi_wdata_vif;
      axi_wresp_vif = axi_cfg.axi_wresp_vif;
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction // connect_phase   

   virtual task run_phase(uvm_phase phase);
      wait(clk_rst_vif.rstn);
      fork
	 manage_sequencer_txn;
	 drive_read_resp_rdy;
	 drive_write_resp_rdy;	 
      join_none
   endtask // run_phase

   task manage_sequencer_txn();
      axi_transaction axi_txn;
      axi_txn = new();

      forever begin
	 seq_item_port.get_next_item(axi_txn);
	 `uvm_info(get_name(), $psprintf(": get next item: %s", axi_txn.convert2string), UVM_MEDIUM)
	 if (axi_txn.rw == READ)
	   drv_rd_addr(axi_txn);
	 else if (axi_txn.rw == WRITE) begin
	    drv_wr_addr(axi_txn);
	    drv_wr_data(axi_txn);	    
	 end	
	 seq_item_port.item_done();	 
      end      
   endtask // manage_sequencer_txn

   task drv_rd_addr (axi_transaction axi_txn);
      while (!axi_raddr_vif.ARREADY) @(posedge clk_rst_vif.clk);
      axi_raddr_vif.ARVALID = 1'b1;
      axi_raddr_vif.ARID    = axi_txn.id;
      axi_raddr_vif.ARADDR  = axi_txn.addr;
      axi_raddr_vif.ARLEN   = axi_txn.length;
      @(posedge clk_rst_vif.clk);
      axi_raddr_vif.ARVALID = 1'b0;
      `uvm_info(get_name(), $psprintf(": axi raddr: %s", axi_txn.convert2string), UVM_MEDIUM)
   endtask // drv_rd_addr

   task drv_wr_addr (axi_transaction axi_txn);
      while (!axi_waddr_vif.AWREADY) @(posedge clk_rst_vif.clk);
      axi_waddr_vif.AWVALID = 1'b1;
      axi_waddr_vif.AWID    = axi_txn.id;
      axi_waddr_vif.AWADDR  = axi_txn.addr;
      axi_waddr_vif.AWLEN   = axi_txn.length;
      @(posedge clk_rst_vif.clk);
      axi_waddr_vif.AWVALID = 1'b0;
      `uvm_info(get_name(), $psprintf(": axi waddr: %s", axi_txn.convert2string), UVM_MEDIUM)
   endtask // drv_wr_addr
   
   task drv_wr_data (axi_transaction axi_txn);
      int i;
      for (i=0; i<axi_txn.length; ++i) begin
	 while (!axi_wdata_vif.WREADY) @(posedge clk_rst_vif.clk) ;
	 axi_wdata_vif.WVALID = 1'b1;
	 axi_wdata_vif.WID    = axi_txn.id;
	 axi_wdata_vif.WDATA  = axi_txn.data[i];
      end
      axi_wdata_vif.WVALID = 1'b0;
      `uvm_info(get_name(), $psprintf(": axi wdata: %s", axi_txn.convert2string), UVM_MEDIUM)	 
   endtask // drv_wr_addr

   task drive_read_resp_rdy;
      forever @(posedge clk_rst_vif.clk) begin
	 axi_rdata_vif.RREADY = 1'b1;
	 wait (axi_rdata_vif.RVALID);
	 @(posedge clk_rst_vif.clk);
	 axi_rdata_vif.RREADY = 1'b0;
      end
   endtask // drive_read_resp_rdy   
	 
   task drive_write_resp_rdy;
      forever @(posedge clk_rst_vif.clk) begin
	 axi_wresp_vif.BREADY = 1'b1;
	 wait (axi_wresp_vif.BVALID);
	 @(posedge clk_rst_vif.clk);
	 axi_wresp_vif.BREADY = 1'b0;
      end
   endtask // drive_write_resp_rdy   

endclass // axi_master_driver

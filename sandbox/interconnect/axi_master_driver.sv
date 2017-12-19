// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_master_driver extends uvm_driver;
   `uvm_component_utils(axi_master_driver)

   axi_config axi_cfg;
   virtual clk_rst_if clk_rst_vif;
   virtual axi_raddr_if axi_raddr_vif;
   virtual axi_rdata_if axi_rdata_vif;
   virtual axi_waddr_if axi_waddr_vif;
   virtual axi_wdata_if axi_wdata_vif;
   virtual axi_wresp_if axi_wresp_vif;   
   
   function void new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      axi_cfg = new(axi_cfg, this);
      clk_rst_vif   = axi_cfg.clk_rst_vif;      
      axi_raddr_vif = axi_cfg.axi_raddr_vif;
      axi_rdata_vif = axi_cfg.axi_rdata_vif;
      axi_waddr_vif = axi_cfg.axi_waddr_vif;
      axi_wdata_vif = axi_cfg.axi_wdata_vif;
      axi_wresp_vif = axi_cfg.axi_wresp_vif;      
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);      
   endfunction // connect_phase

   virtual task run_phase;
      axi_transaction axi_txn;      
      axi_txn = new();
      
      forever begin
	 seq_item_port.get_next_item(axi_txn);
	 if (axi_txn.rw == READ) begin	 
	    fork
	       drv_rd_addr(axi_txn);
	       drv_rd_rsp(axi_txn);
	    join_none
	 else if (axi_txn.rw == WRITE) begin
	    fork	       
	       drv_wr_addr(axi_txn);
	       drv_wr_data(axi_txn);
	       drv_wr_resp(axi_txn);
	    join_none
	 end	 
      seq_item_port.item_done();            
   endtask // run_phase
   
   vitrual task drv_rd_addr(axi_transaction axi_txn);      
      always @(posedge clk_rst_vif.clk) begin
	 if (!clk_rst_vif.rstn) begin
	    axi_raddr_vif.ARID    = 4'b0;
	    axi_raddr_vif.ARADDR  = 32'b0;
	    axi_raddr_vif.ARLEN   = 4'b0;
	    axi_raddr_vif.ARSIZE  = 3'b0;
	    axi_raddr_vif.ARBURST = 2'b0;
	    axi_raddr_vif.ARLOCK  = 2'b0;
	    axi_raddr_vif.ARCACHE = 4'b0;
	    axi_raddr_vif.ARPROT  = 3'b0;
	    axi_raddr_vif.ARVALID = 1'b0;
	    axi_rdata_vif.RREADY = 1'b0;
	 end
	 else begin
	    axi_rdata_vif.RREADY = 1'b1;
	    if (axi_raddr_vif.ARREADY) begin
	       axi_raddr_vif.ARVALID = 1'b1;	    
	       axi_raddr_vif.ARID    = axi_txn.id;
	       axi_raddr_vif.ARADDR  = axi_txn.addr;	    
	       axi_raddr_vif.ARLEN   = axi_txn.length;
	    end
	 end
      end	   
   endtask // drv_rd_addr

   virtual task drv_rd_rsp(axi_transaction axi_txn);      
      always @(posedge clk_rst_vif.clk) begin
	 if (!clk_rst_vif.rstn)
	   axi_rdata_vif.RREADY = 1'b0;
	 else
	   axi_rdata_vif.RREADY = 1'b1;
      end	   
   endtask // drive_read_channels
   
   virtual task drv_wr_addr(axi_transaction axi_txn);
      always @(posedge clk_rst_vif.clk) begin
	 if (!clk_rst_vif.rstn) begin
	    axi_waddr_vif.AWID    = 4'b0;
	    axi_waddr_vif.AWADDR  = 32'b0;
	    axi_waddr_vif.AWLEN   = 4'b0;
	    axi_waddr_vif.AWSIZE  = 3'b0;
	    axi_waddr_vif.AWCACHE = 4'b0;
	    axi_waddr_vif.AWPROT  = 3'b0;
	    axi_waddr_vif.AWVALID = 1'b0;
	 end
	 else if (axi_waddr_vif.AWREADY) begin
	    axi_waddr_vif.AWVALID = 1'b1;
	    axi_waddr_vif.AWID    = axi_txn.id;
	    axi_waddr_vif.AWADDR  = axi_txn.addr;	   
	    axi_waddr_vif.AWLEN   = axi_txn.length;
	 end
      end	         
   endtask // drv_wr_addr   
   
   virtual task drv_wr_data(axi_transaction axi_txn);
      always @(posedge clk_rst_vif.clk) begin
	 if (!clk_rst_vif.rstn) begin
	    axi_wdata_vif.WID    = 4'b0;
	    axi_wdata_vif.WDATA  = 32'b0;
	    axi_wdata_vif.WLAST  = 4'b0;
	    axi_wdata_vif.WVALID = 1'b0;
	 end
	 else if (axi_wdata_vif.WREADY) begin
	    axi_wdata_vif.WVALID = 1'b1;
	    axi_wdata_vif.WID    = axi_txn.id;
	    axi_wdata_vif.WDATA  = axi_txn.wdata;	    
	 end
      end	         
   endtask // drv_wr_data
   
   virtual task drv_wr_resp(axi_transaction axi_txn);
      always @(posedge clk_rst_vif.clk) begin
	 if (!clk_rst_vif.rstn)
	   axi_wresp_vif.BREADY = 1'b0;	    	    
	 else
	   axi_wresp_vif.BREADY = 1'b0;	    	    
      end   
   endtask // drv_wr_resp   
   
endclass // axi_master_driver


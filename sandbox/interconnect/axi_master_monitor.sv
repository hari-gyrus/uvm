// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_master_monitor extends uvm_monitor;   
   `uvm_component_utils(axi_master_monitor)

   axi_config axi_cfg;

   virtual clk_rst_if clk_rst_vif;
   virtual axi_raddr_if axi_raddr_vif;
   virtual axi_rdata_if axi_rdata_vif;
   virtual axi_waddr_if axi_waddr_vif;
   virtual axi_wdata_if axi_wdata_vif;
   virtual axi_wresp_if axi_wresp_vif;

   uvm_analysis_port #(axi_transaction) rd_ana_port;
   uvm_analysis_port #(axi_transaction) wr_ana_port;
   
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
      
      rd_ana_port = new("rd_ana_port", this);
      wr_ana_port = new("wr_ana_port", this);      
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction // connect_phase   

   virtual task run_phase(uvm_phase phase);
      fork
	 mon_rd_addr;
	 mon_rd_data;
	 mon_wr_addr;
	 mon_wr_data;
	 mon_wr_resp;	 
      join_none     
   endtask // run_phase

   task mon_rd_addr;
      axi_transaction axi_txn;
      axi_txn = new();

      forever @(posedge clk_rst_vif.clk) begin
	 if (axi_raddr_vif.ARVALID) begin
	    axi_txn.id     = axi_raddr_vif.ARID;	    
	    axi_txn.addr   = axi_raddr_vif.ARADDR;  
	    axi_txn.length = axi_raddr_vif.ARLEN; 
	 end
	 rd_ana_port.write(axi_txn);	 
      end      
   endtask // mon_rd_addr
   
   task mon_rd_data;
      int i;      
      axi_transaction axi_txn;
      axi_txn = new();

      forever @(posedge clk_rst_vif.clk) begin
	 i = 0;	 
	 while (axi_rdata_vif.RVALID && axi_rdata_vif.RREADY) begin
	    axi_txn.id      = axi_rdata_vif.RID;	    	    
	    axi_txn.data[i] = axi_rdata_vif.RDATA;
	    ++i;	    
	 end	   
	 axi_txn.length = i;	 
	 rd_ana_port.write(axi_txn);
      end      
   endtask // mon_rd_data

   task mon_wr_addr;
      axi_transaction axi_txn;
      axi_txn = new();

      forever @(posedge clk_rst_vif.clk) begin
	 if (axi_waddr_vif.AWVALID) begin
	    axi_txn.id     = axi_waddr_vif.AWID;	    
	    axi_txn.addr   = axi_waddr_vif.AWADDR;  
	    axi_txn.length = axi_waddr_vif.AWLEN; 
	 end	 
	 wr_ana_port.write(axi_txn);	 
      end      
   endtask // mon_wr_addr

   task mon_wr_data;
      int i;	 
      axi_transaction axi_txn;
      axi_txn = new();

      forever @(posedge clk_rst_vif.clk) begin
	 i = 0;	 
	 while (axi_wdata_vif.WVALID && axi_wdata_vif.WREADY) begin
	    axi_txn.id      = axi_wdata_vif.WID;	    
	    axi_txn.data[i] = axi_wdata_vif.WDATA;
	    ++i;	    
	 end	   	 
	 axi_txn.length = i;	 
	 wr_ana_port.write(axi_txn);	 
      end      
   endtask // mon_wr_data

   task mon_wr_resp;
   endtask // mon_wr_resp

endclass // axi_master_monitor

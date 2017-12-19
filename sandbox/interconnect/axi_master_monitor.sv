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

   uvm_analysis_port rd_ana_port;
   uvm_analysis_port wr_ana_port;   
   
   function void new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      axi_cfg = new(axi_cfg, this);
      axi_raddr_vif = axi_cfg.axi_raddr_vif;
      axi_rdata_vif = axi_cfg.axi_rdata_vif;
      axi_waddr_vif = axi_cfg.axi_waddr_vif;
      axi_wdata_vif = axi_cfg.axi_wdata_vif;
      axi_wresp_vif = axi_cfg.axi_wresp_vif;

      rd_ana_port = new(rd_ana_port, this);
      wr_ana_port = new(wr_ana_port, this);      
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction // connect_phase

   virtual task run_phase;
      fork	 
	 mon_rd_data();
	 mon_wr_resp();	 
      join_none      
   endtask // run_phase   

   virtual task mon_rd_data;      
      axi_transaction axi_txn;
      axi_txn = new();
      
      always @(posedge clk_rst_vif.clk) begin	 
	 if (axi_rdata_vif.RVALID) begin
	    axi_txn.id = axi_rdata_vif.RID;
	    axi_txn.data = axi_rdata_vif.RDATA;
	 end
      end
   
   rd_ana_port.write(axi_txn);   
   endtask // mon_rd_data

   virtual task mon_wr_resp;
      axi_transaction axi_txn;
      axi_txn = new();

      always @(posedge clk_rst_vif.clk) begin	 
	 if (axi_wdata_vif.WVALID) begin
	    axi_txn.id = axi_wdata_vif.WID;
	    axi_txn.data = axi_wdata_vif.WDATA;
	 end
      end      
   wr_ana_port.write(axi_txn);   
   endtask // mon_wr_resp   

endclass // axi_master_monitor


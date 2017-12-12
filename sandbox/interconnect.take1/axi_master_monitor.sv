// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// axi master monitor
//

class axi_master_monitor extends uvm_monitor;
   `uvm_component_utils(axi_master_monitor)

   // monitor sub components: config, dut interface
   axi_config axi_cfg;
   virtual clkrst_if clkrst_vif;   
   virtual axi_waddr_if axi_waddr_vif;
   virtual axi_wdata_if axi_wdata_vif;
   virtual axi_wresp_if axi_wresp_vif;
   virtual axi_raddr_if axi_raddr_vif;
   virtual axi_rdata_if axi_rdata_vif;

   // monitor analysis port
   uvm_analysis_port #(axi_transaction) axi_wr_aport;
   uvm_analysis_port #(axi_transaction) axi_rd_aport;      
   
   logic [3:0] axi_awlen;
   logic [AXI_ADDR_WIDTH-1: 0] axi_awaddr;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   // build_phase
   //   1. new analysis ports 
   //   2. virtual interface

   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);

      //   1. new analysis ports 
      axi_wr_aport = new ("axi_wr_aport", this);
      axi_rd_aport = new ("axi_rd_aport", this);

      //   2. virtual interface
      clkrst_vif    = axi_cfg.clkrst_vif;      
      axi_waddr_vif = axi_cfg.axi_waddr_vif;
      axi_wdata_vif = axi_cfg.axi_wdata_vif;
      axi_wresp_vif = axi_cfg.axi_wresp_vif;
      axi_raddr_vif = axi_cfg.axi_raddr_vif;
      axi_rdata_vif = axi_cfg.axi_rdata_vif;
      
   endfunction // build_phase
   
   // run_phase 
   //   1. wait for reset
   //   2. fork off monitor tasks

   task run_phase (uvm_phase phase);

      //   1. wait for reset
      wait (!clkrst_vif.rstn);
      @(posedge clkrst_vif.rstn);
      
      fork
	 monitor_wr_addr();
	 monitor_wr_data();
	 monitor_wr_resp();	 
	 monitor_rd_addr();
	 monitor_rd_data();	 	 
      join_none
      
   endtask // run_phase

   task monitor_wr_addr();           
      wait (axi_waddr_vif.axi_awvalid & axi_waddr_vif.axi_awready) @(posedge clkrst_vif.clk);

      axi_awlen  = axi_waddr_vif.axi_awlen;  
      axi_awaddr = axi_waddr_vif.axi_awaddr;
      
   endtask // monitor_wr_addr

   task monitor_wr_data();
      int i;      
      axi_transaction axi_txn;

      axi_txn = new();
      
      forever @(posedge clkrst_vif.clk) begin
	 wait (axi_wdata_vif.axi_wvalid & axi_wdata_vif.axi_wready);
	 
	 axi_txn.length = axi_waddr_vif.axi_awlen;
	 axi_txn.addr   = axi_waddr_vif.axi_awaddr;
	 axi_txn.id     = axi_wdata_vif.axi_wid;
	 axi_txn.data   = new[axi_txn.length];

	 i = 0;	 
	 while (!axi_wdata_vif.axi_wlast) begin
	    axi_txn.data[i] = axi_wdata_vif.axi_wdata;
	    @(posedge clkrst_vif.clk);	    
	    ++i;
	 end	 

	 axi_wr_aport.write(axi_txn);
	 `uvm_info("monitor_wr_data", $psprintf("Sending AXI Write Txn to aport: %s", axi_txn.convert2string), UVM_MEDIUM)
		   
      end // forever @(posedge clkrst_vif.clk)
      
   endtask // monitor_wr_data
     
   // dummy for now (randomized with write)
   task monitor_wr_resp();
   endtask // monitor_wr_resp
   
   // dummy for now (randomized with write)
   task monitor_rd_addr();
   endtask // monitor_rd_addr
   
   // dummy for now (randomized with write)
   task monitor_rd_data();
   endtask // monitor_rd_data   

endclass // axi_master_monitor



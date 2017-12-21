// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_monitor extends uvm_monitor;   
   `uvm_component_utils(ocp_slave_monitor)

   ocp_config ocp_cfg;

   virtual clk_rst_if clk_rst_vif;
   virtual ocp_if ocp_vif;

   uvm_analysis_port #(ocp_transaction) rd_ana_port;
   uvm_analysis_port #(ocp_transaction) wr_ana_port;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      clk_rst_vif = ocp_cfg.clk_rst_vif;
      ocp_vif = ocp_cfg.ocp_vif;

      rd_ana_port = new("rd_ana_port", this);
      wr_ana_port = new("wr_ana_port", this);      
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction // connect_phase   

   virtual task run_phase(uvm_phase phase);
      ocp_transaction ocp_txn;
      ocp_txn = new();

      wait(clk_rst_vif.rstn);

      forever @(posedge clk_rst_vif.clk) begin
	 if (ocp_vif.MCmd == WRITE && ocp_vif.MDataValid) begin
	    ocp_txn.id = ocp_vif.MTagID;
	    ocp_txn.addr = ocp_vif.MAddr;
	    ocp_txn.data = ocp_vif.Mdata;	    
	    wr_ana_port.write(ocp_txn);	    
	 end
	 else if (ocp_vif.MCmd == READ) begin
	    ocp_txn.id = ocp_vif.MTagID;
	    ocp_txn.addr = ocp_vif.MAddr;
	    @(ocp_vif.SResp == OCP_DVA);
	    ocp_txn.data = ocp_vif.Sdata;
	    rd_ana_port.write(ocp_txn);	    
	 end	 
      end            
   endtask // run_phase

endclass // ocp_slave_monitor

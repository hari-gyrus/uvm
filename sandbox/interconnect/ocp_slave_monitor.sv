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
      int i;
      bit [3:0] prev_MCmd;
      ocp_transaction ocp_txn;
      ocp_txn = new();

      wait(clk_rst_vif.rstn);

      forever @(posedge clk_rst_vif.clk) begin
	 if (ocp_vif.MCmd == OCP_WRITE && ocp_vif.MDataValid) begin
	    ocp_txn.id = ocp_vif.MTagID;
	    ocp_txn.addr = ocp_vif.MAddr;	    	    	    
	    ocp_txn.data[i] = ocp_vif.Mdata;	    	       
	 end
	 else if (ocp_vif.MCmd == OCP_READ) begin
	    ocp_txn.id = ocp_vif.MTagID;
	    ocp_txn.addr = ocp_vif.MAddr;
	    @(ocp_vif.SResp == OCP_DVA);
	    ocp_txn.data[i] = ocp_vif.Sdata;
	 end	 

	 if (prev_MCmd == OCP_IDLE && ocp_vif.MCmd != OCP_IDLE) begin
	    ++i;
	 end
	 else if (prev_MCmd == OCP_WRITE && ocp_vif.MCmd == OCP_IDLE) begin
	    i = 0; wr_ana_port.write(ocp_txn);
	 end	 
	 else if (prev_MCmd == OCP_READ && ocp_vif.MCmd == OCP_IDLE) begin
	    i = 0; rd_ana_port.write(ocp_txn);
	 end	 
    	 else begin
	   i = 0;	 
	 end
	      
	 prev_MCmd = ocp_vif.MCmd;
      end      
   endtask // run_phase

endclass // ocp_slave_monitor

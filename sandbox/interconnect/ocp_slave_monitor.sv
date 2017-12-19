// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_monitor extends uvm_monitor;
   `uvm_config_utils(ocp_slave_monitor)

   ocp_config ocp_cfg;
   virtual clk_rst_if clk_rst_vif;
   virtual ocp_if ocp_vif;   

   uvm_analysis_port rd_ana_port;
   uvm_analysis_port wr_ana_port;   

   function void new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      ocp_cfg = new("ocp_cfg", this);
      clk_rst_vif = ocp_cfg.clk_rst_if;
      ocp_vif = ocp_cfg.ocp_if;  

      rd_ana_port = new("rd_ana_port", this);
      wr_ana_port = new("wr_ana_port", this);     
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);      
   endfunction // connect_phase
   
   task run_phase;
      ocp_transaction ocp_txn;
      ocp_txn = new();
      
      always @(posedge clk_rst_vif.clk)	begin
	 if (ocp_vif.MCmd == WRITE && ocp_vif.MDataValid) begin
	    ocp_txn.rw = WRITE;
	    ocp_txn.id = ocp_vif.MTagID;
	    ocp_txn.addr = ocp_vif.MAddr;
	    ocp_txn.data = ocp_vif.Mdata;	    
	    wr_ana_port.write(ocp_txn);	    
	 end
	 else if (ocp_vif.MCmd == READ) begin
	    ocp_txn.rw = READ;
	    ocp_txn.id = ocp_vif.MTagId;
	    ocp_txn.addr = ocp_vif.MAddr;
	    wait @(ocp_vif.SResp == OCP_DVA);
	    ocp_txn.data = ocp_vid.Sdata;
	    rd_ana_port.write(ocp_txn);	    
	 end	 
      end            
   endtask // run_phase      
   
endclass // ocp_slave_monitor



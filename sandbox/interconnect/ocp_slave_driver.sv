// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_driver extends uvm_driver #(ocp_transaction);   
   `uvm_component_utils(ocp_slave_driver)

   ocp_config ocp_cfg;

   virtual clk_rst_if clk_rst_vif;
   virtual ocp_if ocp_vif;

   logic [31:0] mem [(16*1024)-1:0];
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      clk_rst_vif = ocp_cfg.clk_rst_vif;
      ocp_vif = ocp_cfg.ocp_vif;
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction // connect_phase   

   virtual task run_phase(uvm_phase phase);
      ocp_transaction ocp_txn;
      ocp_txn = new();

      wait(clk_rst_vif.rstn);
      
      forever @(posedge clk_rst_vif.clk) begin
	 seq_item_port.get_next_item(ocp_txn);
	 if (ocp_vif.MCmd == OCP_READ) begin
	    ocp_vif.SCmdAccept  = 1'b1;
	    ocp_vif.SDataAccept = 1'b0;	      
	    ocp_vif.SResp       = OCP_DVA;
	    ocp_vif.Sdata       = mem[ {ocp_vif.MTagID[2:0],ocp_vif.MAddr[12:0]} ];	    
	    @(posedge clk_rst_vif.clk);
	    ocp_vif.SCmdAccept  = 1'b0;
	    ocp_vif.SDataAccept = 1'b0;	      
	    ocp_vif.SResp       = OCP_NULL;
	    ocp_vif.Sdata       = 32'h0;	    	    
	 end
	 else if (ocp_vif.MCmd == OCP_WRITE && ocp_vif.MDataValid) begin
	    ocp_vif.SCmdAccept  = 1'b1;
	    ocp_vif.SDataAccept = 1'b1;		
	    ocp_vif.SResp        = OCP_DVA;	
	    mem[ {ocp_vif.MTagID[2:0],ocp_vif.MAddr[12:0]} ] = ocp_vif.Mdata;		
	    @(posedge clk_rst_vif.clk);
	    ocp_vif.SCmdAccept  = 1'b0;
	    ocp_vif.SDataAccept = 1'b0;		
	    ocp_vif.SResp        = OCP_NULL;	
	 end	 
	 seq_item_port.item_done();
      end // forever @(posedge clk_rst_vif.clk)      
   endtask // run_phase
   
endclass // ocp_slave_driver

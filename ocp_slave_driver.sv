// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_driver extends uvm_driver;
   `uvm_component_utils(ocp_slave_driver)

   ocp_config ocp_cfg;
   virtual clk_rst_if clk_rst_vif;
   virtual ocp_if ocp_vif;

   logic [31:0] mem [(16*1024)-1:0];
   
   function void new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);      

      ocp_cfg = new("ocp_cfg", this);      
      clk_rst_vif = ocp_cfg.clk_rst_if;
      ocp_vif = ocp_cfg.ocp_vif;      
   endfunction // build_phase

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);      
   endfunction // connect_phase   

   virtual task run_phase;
      ocp_transaction ocp_txn;
      ocp_txn = new();     
      
      seq_item_port.get_next_item(ocp_txn);

      always @(posedge clk_rst_vif.clk) 
	begin
	   if(!clk_rst_vif.rstn)
	     begin
		ocp_vif.SCmdAccept = 1'b0;
		ocp_vif.SDataAccept = 1'b0;
		ocp_vif.SResp = OCP_NULL;
		ocp_vif.Sdata = 'd0;		
	     end
	   else	if (ocp_vif.MCmd == OCP_READ)
	     begin
		ocp_vif.SCmdAccept = 1'b1;
		ocp_vif.SDataAccept = 1'b0;	      
		ocp_vif.SResp = OCP_DVA;
		ocp_vif.Sdata = mem[ {ocp_vif.MTagID[2:0],ocp_vif.MAddr[12:0]} ];
	     end
	   else if (ocp_vif.MCmd == OCP_WRITE)
	     begin
		ocp_vif.SCmdAccept = 1'b1;
		ocp_vif.SDataAccept = 1'b1;		
		ocp_vif.Srep = OCP_DVA;	
		if (ocp_vif.MDataVlid)
		  mem[ {ocp_vif.MTadID[2:0],ocp_vif.MAddr[12:0]} ] = ocp_vif.Mdata;		
	     end
	   else
	     begin
		ocp_vif.SCmdAccept = 1'b0;
		ocp_vif.SDataAccept = 1'b0;
		ocp_vif.SResp = OCP_NULL;
		ocp_vif.Sdata = 'd0;		
	     end // else: !if(ocp_vif.MCmd == OCP_WRITE)	   
	end
   
      seq_item_port.item_done();     
   endtask // run_phase
   
endclass // ocp_slave_driver


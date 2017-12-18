// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

`include "uvm_macros.svh"
`include "axi_ocp_pkg.sv"
`include "interfaces.svh"
`include "alive_test.sv"   

module testbench;

   //
   // packages
   //
   
   import uvm_pkg::*;
   import axi_ocp_pkg::*;

   //
   // interfaces
   //
   
   ocp_if ocp_vif();
   clkrst_if clkrst_vif();

   axi_waddr_if axi_waddr_vif1();
   axi_wdata_if axi_wdata_vif1();
   axi_wresp_if axi_wresp_vif1();
   axi_raddr_if axi_raddr_vif1();
   axi_rdata_if axi_rdata_vif1();

   axi_waddr_if axi_waddr_vif2(); 
   axi_wdata_if axi_wdata_vif2(); 
   axi_wresp_if axi_wresp_vif2(); 
   axi_raddr_if axi_raddr_vif2(); 
   axi_rdata_if axi_rdata_vif2();		       

   //
   // dut
   //

   interconnect interconnect (.clkrst_if(clkrst_vif),
			      .ocp_if(ocp_vif),
			      .waddr_if_1(axi_waddr_vif1),
			      .wdata_if_1(axi_wdata_vif1),
			      .wresp_if_1(axi_wresp_vif1),
			      .raddr_if_1(axi_raddr_vif1),
			      .rdata_if_1(axi_rdata_vif1),			  
			      .waddr_if_2(axi_waddr_vif2), 
			      .wdata_if_2(axi_wdata_vif2), 
			      .wresp_if_2(axi_wresp_vif2), 
			      .raddr_if_2(axi_raddr_vif2), 
			      .rdata_if_2(axi_rdata_vif2));
   
   // 
   // waveform
   // 

   initial
     begin
	$dumpfile("dump.vcd");
	$dumpvars(0, testbench);
	#100000 $finish;
     end

   //
   // clk & reset
   //
   
   initial
     begin
	clkrst_vif.clk = 0;
	forever #5 clkrst_vif.clk = ~clkrst_vif.clk;	
     end

   initial
     begin
	clkrst_vif.rstn = 0;
	#1000 clkrst_vif.rstn = 1;	
     end

   //
   // setup config
   //

   initial
     begin
	ocp_config ocp_cfg;
	axi_config axi_cfg1, axi_cfg2;

	ocp_cfg = new();	
	ocp_cfg.ocp_vif = ocp_vif;	
	ocp_cfg.clkrst_vif = clkrst_vif;   	
	  
	axi_cfg1 = new();	
	axi_cfg1.clkrst_vif = clkrst_vif;   	
	axi_cfg1.axi_waddr_vif = axi_waddr_vif1;	
	axi_cfg1.axi_wdata_vif = axi_wdata_vif1;
	axi_cfg1.axi_wresp_vif = axi_wresp_vif1;
	axi_cfg1.axi_raddr_vif = axi_raddr_vif1;
	axi_cfg1.axi_rdata_vif = axi_rdata_vif1;
	
	axi_cfg2 = new();	
	axi_cfg2.clkrst_vif = clkrst_vif;   	
	axi_cfg2.axi_waddr_vif = axi_waddr_vif2;	
	axi_cfg2.axi_wdata_vif = axi_wdata_vif2;
	axi_cfg2.axi_wresp_vif = axi_wresp_vif2;
	axi_cfg2.axi_raddr_vif = axi_raddr_vif2;
	axi_cfg2.axi_rdata_vif = axi_rdata_vif2;

	uvm_config_db #(ocp_config)::set (null, "", "ocp_cfg",  ocp_cfg);		
	uvm_config_db #(axi_config)::set (null, "", "axi_cfg1", axi_cfg1);
	uvm_config_db #(axi_config)::set (null, "", "axi_cfg2", axi_cfg1);
     end
      
   //
   // run test
   //
   
   initial
     begin
	run_test("alive_test");       
     end   

endmodule // testbench


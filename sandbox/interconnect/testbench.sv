// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

`include "uvm_macros.svh"
`include "interfaces.sv"
`include "package.sv"

module testbench;

   import uvm_pkg::*;
   import tb_pkg::*;   
   `include "alive_test.sv"
   
   clk_rst_if   clk_rst_if();  
   ocp_if       ocp_if();   
   axi_raddr_if axi_raddr_if1();   
   axi_rdata_if axi_rdata_if1();   
   axi_waddr_if axi_waddr_if1();  
   axi_wdata_if axi_wdata_if1();   
   axi_wresp_if axi_wresp_if1();
   axi_raddr_if axi_raddr_if2();   
   axi_rdata_if axi_rdata_if2();   
   axi_waddr_if axi_waddr_if2();  
   axi_wdata_if axi_wdata_if2();   
   axi_wresp_if axi_wresp_if2();

   interconnect dut (.clk_rst_if    (clk_rst_if),   
		     .ocp_if	    (ocp_if),     
		     .axi_raddr_s1  (axi_raddr_if1),
		     .axi_rdata_s1  (axi_rdata_if1),
		     .axi_waddr_s1  (axi_waddr_if1),
		     .axi_wdata_s1  (axi_wdata_if1),
		     .axi_wresp_s1  (axi_wresp_if1),
		     .axi_raddr_s2  (axi_raddr_if2),
		     .axi_rdata_s2  (axi_rdata_if2),
		     .axi_waddr_s2  (axi_waddr_if2),
		     .axi_wdata_s2  (axi_wdata_if2),
		     .axi_wresp_s2  (axi_wresp_if2));
      
   initial
     begin
	$dumpfile("dump.vcd");
	$dumpvars(0, testbench);
     end

   initial begin
      clk_rst_if.clk = 0; 
      clk_rst_if.rstn = 1'b0;
      #100 clk_rst_if.rstn = 1'b1;                  
      #1000 $finish;      
   end
   
   always #5 clk_rst_if.clk = ~clk_rst_if.clk;   
   
   initial
     uvm_pkg::run_test("alive_test");	
   
   initial begin	
      ocp_config ocp_s1_cfg;
      axi_config axi_m1_cfg, axi_m2_cfg;   
      
      ocp_s1_cfg             = new();   
      ocp_s1_cfg.ocp_vif     = ocp_if;
      ocp_s1_cfg.clk_rst_vif = clk_rst_if;
      
      axi_m1_cfg               = new();
      axi_m1_cfg.clk_rst_vif   = clk_rst_if;
      axi_m1_cfg.axi_raddr_vif = axi_raddr_if1;
      axi_m1_cfg.axi_rdata_vif = axi_rdata_if1;
      axi_m1_cfg.axi_waddr_vif = axi_waddr_if1;
      axi_m1_cfg.axi_wdata_vif = axi_wdata_if1;
      axi_m1_cfg.axi_wresp_vif = axi_wresp_if1;
      
      axi_m2_cfg               = new();
      axi_m2_cfg.clk_rst_vif   = clk_rst_if;
      axi_m2_cfg.axi_raddr_vif = axi_raddr_if2;
      axi_m2_cfg.axi_rdata_vif = axi_rdata_if2;
      axi_m2_cfg.axi_waddr_vif = axi_waddr_if2;
      axi_m2_cfg.axi_wdata_vif = axi_wdata_if2;
      axi_m2_cfg.axi_wresp_vif = axi_wresp_if2;
      
      uvm_config_db #(ocp_config)::set(null, "", "ocp_s1_cfg", ocp_s1_cfg);
      uvm_config_db #(axi_config)::set(null, "", "axi_m1_cfg", axi_m1_cfg);
      uvm_config_db #(axi_config)::set(null, "", "axi_m2_cfg", axi_m2_cfg);      
   end // initial begin
   
endmodule // testbench

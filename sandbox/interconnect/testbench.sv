// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

`include "uvm_macros.svh"
`include "interfaces.sv"

module testbench;

   // interfaces
   
   ocp_if       ocp_if();   
   clk_rst_if   clk_rst_if();  
   axi_raddr_if axi_raddr_if();   
   axi_rdata_if axi_rdata_if();   
   axi_waddr_if axi_waddr_if();  
   axi_wdata_if axi_wdata_if();   
   axi_wresp_if axi_wresp_if();

   // dut

   interconnect dut (.clk_rst_if	(clk_rst_if),   
		     .ocp_if	        (ocp_if),     
		     .axi_raddr_if	(axi_raddr_if),
		     .axi_rdata_if	(axi_rdata_if),
		     .axi_waddr_if	(axi_waddr_if),
		     .axi_wdata_if	(axi_wdata_if),
		     .axi_wresp_if      (axi_wresp_if));
   
   
endmodule // testbench

// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

module interconnect ( clk_rst_if.sink    clk_rst_if,
		      ocp_if.master      ocp_if,
		      axi_raddr_if.slave axi_raddr_if1,
		      axi_rdata_if.slave axi_rdata_if1,
		      axi_waddr_if.slave axi_waddr_if1,
		      axi_wdata_if.slave axi_wdata_if1,
		      axi_wresp_if.slave axi_wresp_if1,		      
		      axi_raddr_if.slave axi_raddr_if2,
		      axi_rdata_if.slave axi_rdata_if2,
		      axi_waddr_if.slave axi_waddr_if2,
		      axi_wdata_if.slave axi_wdata_if2,
		      axi_wresp_if.slave axi_wresp_if2);
   


endmodule // interconnect


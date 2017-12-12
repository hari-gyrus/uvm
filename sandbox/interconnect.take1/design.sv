// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

module interconnect (// clk & reset
		     clkrst_if.sink clkrst_if,
		     // axi slave 1
		     axi_waddr_if.slave waddr_if_1,
		     axi_wdata_if.slave wdata_if_1,
		     axi_wresp_if.slave wresp_if_1,
		     axi_raddr_if.slave raddr_if_1,
		     axi_rdata_if.slave rdata_if_1,
		     // axi slave 2
		     axi_waddr_if.slave waddr_if_2, 
		     axi_wdata_if.slave wdata_if_2, 
		     axi_wresp_if.slave wresp_if_2, 
		     axi_raddr_if.slave raddr_if_2, 
		     axi_rdata_if.slave rdata_if_2,
		     // ocp master
		     ocp_if.master ocp_if);

   // always ready

   always @(posedge clkrst_if.clk) begin
      if (!clkrst_if.rstn) begin
	 waddr_if_1.axi_awready = 1'b0;
	 wdata_if_1.axi_wready  = 1'b0;
	 wresp_if_1.axi_bvalid  = 1'b0;
      end 
      else begin
	 waddr_if_1.axi_awready = 1'b1;
	 wdata_if_1.axi_wready  = 1'b1;
	 
	 if (wdata_if_1.axi_wvalid) begin
	    wresp_if_1.axi_bvalid = 1'b1;	    
	 end	 
      end
   end         

endmodule	     
		

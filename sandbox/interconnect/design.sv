// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

`include "defines.sv"

module interconnect ( clk_rst_if.sink    clk_rst_if,
		      ocp_if.master      ocp_if,
		      axi_raddr_if.slave axi_raddr_s1,
		      axi_rdata_if.slave axi_rdata_s1,
		      axi_waddr_if.slave axi_waddr_s1,
		      axi_wdata_if.slave axi_wdata_s1,
		      axi_wresp_if.slave axi_wresp_s1,		      
		      axi_raddr_if.slave axi_raddr_s2,
		      axi_rdata_if.slave axi_rdata_s2,
		      axi_waddr_if.slave axi_waddr_s2,
		      axi_wdata_if.slave axi_wdata_s2,
		      axi_wresp_if.slave axi_wresp_s2);

   // axi read address slave 1
   logic [3:0]          ARID_S1; 
   logic [AW-1:0] 	ARADDR_S1;
   logic [3:0] 		ARLEN_S1;
   logic [2:0] 		ARSIZE_S1;
   logic [1:0] 		ARBURST_S1;
   logic [1:0] 		ARLOCK_S1;
   logic [3:0] 		ARCACHE_S1;
   logic [2:0] 		ARPROT_S1;
   logic                ARVALID_S1;   

   // axi read address slave 2
   logic [3:0]          ARID_S2; 
   logic [AW-1:0] 	ARADDR_S2;
   logic [3:0] 		ARLEN_S2;
   logic [2:0] 		ARSIZE_S2;
   logic [1:0] 		ARBURST_S2;
   logic [1:0] 		ARLOCK_S2;
   logic [3:0] 		ARCACHE_S2;
   logic [2:0] 		ARPROT_S2;
   logic                ARVALID_S2;   

   // axi write address slave 1
   logic [3:0] 		AWID_S1;
   logic [AW-1:0] 	AWADDR_S1;
   logic [3:0] 		AWLEN_S1;
   logic [2:0] 		AWSIZE_S1;
   logic [3:0] 		AWCACHE_S1;
   logic [2:0] 		AWPROT_S1;
   logic 		AWVALID_S1;

   // axi write address slave 2
   logic [3:0] 		AWID_S2;
   logic [AW-1:0] 	AWADDR_S2;
   logic [3:0] 		AWLEN_S2;
   logic [2:0] 		AWSIZE_S2;
   logic [3:0] 		AWCACHE_S2;
   logic [2:0] 		AWPROT_S2;
   logic 		AWVALID_S2;

   // misc
   logic                SEND_BRESP_s1;
   logic                SEND_BRESP_s2;		
 	   
   // axi read slave 1, 2
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 // slave 1
	 ARID_S1     = 4'b0; 
	 ARADDR_S1   = 32'b0;
	 ARLEN_S1    = 4'b0;
	 ARSIZE_S1   = 3'b0;
	 ARBURST_S1  = 2'b0;
	 ARLOCK_S1   = 2'b0; 
	 ARCACHE_S1  = 4'b0;
	 ARPROT_S1   = 3'b0;
	 ARVALID_S1  = 1'b0;	 
	 // slave 2
	 ARID_S2     = 4'b0; 
	 ARADDR_S2   = 32'b0;
	 ARLEN_S2    = 4'b0;
	 ARSIZE_S2   = 3'b0;
	 ARBURST_S2  = 2'b0;
	 ARLOCK_S2   = 2'b0; 
	 ARCACHE_S2  = 4'b0;
	 ARPROT_S2   = 3'b0;
	 ARVALID_S2  = 1'b0;	 
      end // if (!clk_rst_if.rstn)   
      else begin	 
	 // slave 1
	 ARVALID_S1 = axi_raddr_s1.ARVALID;	    

	 if (axi_raddr_s1.ARVALID) begin
	    ARID_S1     = axi_raddr_s1.ARID; 
	    ARADDR_S1   = axi_raddr_s1.ARADDR;
	    ARLEN_S1    = axi_raddr_s1.ARLEN;
	    ARSIZE_S1   = axi_raddr_s1.ARSIZE;
	    ARBURST_S1  = axi_raddr_s1.ARBURST;
	    ARLOCK_S1   = axi_raddr_s1.ARLOCK; 
	    ARCACHE_S1  = axi_raddr_s1.ARCACHE;
	    ARPROT_S1   = axi_raddr_s1.ARPROT;
	 end	 
         // slave 2
	 ARVALID_S2 = axi_raddr_s1.ARVALID;	    

	 if (axi_raddr_s2.ARVALID) begin
	    ARID_S2     = axi_raddr_s2.ARID; 
	    ARADDR_S2   = axi_raddr_s2.ARADDR;
	    ARLEN_S2    = axi_raddr_s2.ARLEN;
	    ARSIZE_S2   = axi_raddr_s2.ARSIZE;
	    ARBURST_S2  = axi_raddr_s2.ARBURST;
	    ARLOCK_S2   = axi_raddr_s2.ARLOCK; 
	    ARCACHE_S2  = axi_raddr_s2.ARCACHE;
	    ARPROT_S2   = axi_raddr_s2.ARPROT;
	 end 	 
      end // else: !if(!clk_rst_if.rstn)      
   end // always @ (posedge clk_rst_if.clk)   

   always @(posedge clk_rst_if.clk) begin      
      if (!clk_rst_if.rstn) begin
	 axi_raddr_s1.ARREADY = 1'b0;	 
	 axi_raddr_s2.ARREADY = 1'b0;	 
      end
      else begin
	 axi_raddr_s1.ARREADY = 1'b1;	 
	 axi_raddr_s2.ARREADY = 1'b1;	 	 
      end      
   end   

   // axi read data slave 1, 2
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 // slave 1
	 axi_rdata_s1.RID    = 4'b0;
	 axi_rdata_s1.RDATA  = 32'b0;
	 axi_rdata_s1.RRESP  = 2'b0;
	 axi_rdata_s1.RLAST  = 4'b0;
	 axi_rdata_s1.RVALID = 4'b0;	 
	 // slave 2
	 axi_rdata_s2.RID    = 4'b0;
	 axi_rdata_s2.RDATA  = 32'b0;
	 axi_rdata_s2.RRESP  = 2'b0;
	 axi_rdata_s2.RLAST  = 4'b0;
	 axi_rdata_s2.RVALID = 4'b0;	 
      end // if (!clk_rst_if.rstn)      
      else begin
	 // slave 1
	 if (axi_rdata_s1.RREADY && ocp_if.SResp == OCP_DVA && ocp_if.MTagID < 8) begin
	    axi_rdata_s1.RRESP  = 2'b0;
	    axi_rdata_s1.RLAST  = 1'b1;
	    axi_rdata_s1.RVALID = 1'b1;
	    axi_rdata_s1.RID    = ocp_if.MTagID;
	    axi_rdata_s1.RDATA  = ocp_if.Sdata;	 
	 end	 
	 else begin
	    axi_rdata_s1.RID    = 4'b0;
	    axi_rdata_s1.RDATA  = 32'b0;
	    axi_rdata_s1.RRESP  = 2'b0;
	    axi_rdata_s1.RLAST  = 4'b0;
	    axi_rdata_s1.RVALID = 4'b0;	 
	 end // else: !if(axi_rdata_s1.RREADY)	 

	 // slave 2
	 if (axi_rdata_s2.RREADY && ocp_if.SResp == OCP_DVA && ocp_if.MTagID >= 8) begin
	    axi_rdata_s2.RRESP  = 2'b0;
	    axi_rdata_s2.RLAST  = 1'b1;
	    axi_rdata_s2.RVALID = 1'b1;
	    axi_rdata_s2.RID    = ocp_if.MTagID;
	    axi_rdata_s2.RDATA  = ocp_if.Sdata;	 
	 end	 
	 else begin
	    axi_rdata_s2.RID    = 4'b0;
	    axi_rdata_s2.RDATA  = 32'b0;
	    axi_rdata_s2.RRESP  = 2'b0;
	    axi_rdata_s2.RLAST  = 4'b0;
	    axi_rdata_s2.RVALID = 4'b0;	 
	 end // else: !if(axi_rdata_s2.RREADY)	 
      end // else: !if(!clk_rst_if.rstn)
   end // always @ (posedge clk_rst_if.clk)
   
   // axi write address slave 1,2 
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 // slave 1
	 AWID_S1     = 4'b0;	 
	 AWADDR_S1   = 32'b0;	 
	 AWLEN_S1    = 4'b0;	 
	 AWSIZE_S1   = 3'b0;	 
	 AWCACHE_S1  = 4'b0;
	 AWPROT_S1   = 3'b0;
	 AWVALID_S1  = 1'b0;	
	 // slave 2
	 AWID_S2     = 4'b0;	 
	 AWADDR_S2   = 32'b0;	 
	 AWLEN_S2    = 4'b0;	 
	 AWSIZE_S2   = 3'b0;	 
	 AWCACHE_S2  = 4'b0;
	 AWPROT_S2   = 3'b0;	
	 AWVALID_S2  = 1'b0;	
      end
      else begin
	 // slave 1
	 AWVALID_S1  = axi_waddr_s1.AWVALID;	    

	 if (axi_waddr_s1.AWVALID) begin
	    AWID_S1     = axi_waddr_s1.AWID;  
	    AWADDR_S1   = axi_waddr_s1.AWADDR; 
	    AWLEN_S1    = axi_waddr_s1.AWLEN;  
	    AWSIZE_S1   = axi_waddr_s1.AWSIZE; 
	    AWCACHE_S1  = axi_waddr_s1.AWCACHE;
	    AWPROT_S1   = axi_waddr_s1.AWPROT;
	 end
	 else begin
	    AWID_S1     = 4'b0;	 
	    AWADDR_S1   = 32'b0;	 
	    AWLEN_S1    = 4'b0;	 
	    AWSIZE_S1   = 3'b0;	 
	    AWCACHE_S1  = 4'b0;
	    AWPROT_S1   = 3'b0;
	    AWVALID_S1  = 1'b1;	    
	 end	 

	 // slave 2
	 AWVALID_S2  = axi_waddr_s1.AWVALID;	    	    

	 if (axi_waddr_s2.AWVALID) begin
	    AWID_S2     = axi_waddr_s2.AWID;  
	    AWADDR_S2   = axi_waddr_s2.AWADDR; 
	    AWLEN_S2    = axi_waddr_s2.AWLEN;  
	    AWSIZE_S2   = axi_waddr_s2.AWSIZE; 
	    AWCACHE_S2  = axi_waddr_s2.AWCACHE;
	    AWPROT_S2   = axi_waddr_s2.AWPROT;
	 end
	 else begin
	    AWID_S2     = 4'b0;	 
	    AWADDR_S2   = 32'b0;	 
	    AWLEN_S2    = 4'b0;	 
	    AWSIZE_S2   = 3'b0;	 
	    AWCACHE_S2  = 4'b0;
	    AWPROT_S2   = 3'b0;	
	    AWVALID_S2  = 1'b1;	    
	 end // else: !if(axi_waddr_s2.AWVALID)	 
      end // else: !if(!clk_rst_if.rstn)      
   end // always @ (posedge clk_rst_if.clk)   

   // axi write addr interface
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 axi_waddr_s1.AWREADY = 1'b0;
	 axi_waddr_s2.AWREADY = 1'b0;
      end // if (!clk_rst_if.rstn)      
      else begin
	 axi_waddr_s1.AWREADY = 1'b1;
	 axi_waddr_s2.AWREADY = 1'b1;
      end // else: !if(!clk_rst_if.rstn)
   end // always @ (posedge clk_rst_if.clk)

				      
   // axi write data interface
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 axi_wdata_s1.WREADY = 1'b0;
	 axi_wdata_s2.WREADY = 1'b0;
      end // if (!clk_rst_if.rstn)      
      else begin
	 axi_wdata_s1.WREADY = 1'b1;
	 axi_wdata_s2.WREADY = 1'b1;
      end // else: !if(!clk_rst_if.rstn)
   end // always @ (posedge clk_rst_if.clk)

   // axi write resp interface
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 SEND_BRESP_s1 = 1'b0;
	 SEND_BRESP_s2 = 1'b0;	 
      end // if (!clk_rst_if.rstn)      
      else begin
	 if (axi_wdata_s1.WVALID)
	   SEND_BRESP_s1 = 1'b1;	    
	 else if (SEND_BRESP_s1 && axi_wdata_s1.WREADY)
	   SEND_BRESP_s1 = 1'b0;

	 if (axi_wdata_s2.WVALID) 
	   SEND_BRESP_s2 = 1'b1;	    
	 else if (SEND_BRESP_s2 && axi_wdata_s2.WREADY)
	   SEND_BRESP_s2 = 1'b0;
      end // else: !if(!clk_rst_if.rstn)
   end // always @ (posedge clk_rst_if.clk)
      
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 // slave 1
	 axi_wresp_s1.BID = 4'b0;
	 axi_wresp_s1.BRESP = 2'b0;
	 axi_wresp_s1.BVALID = 1'b0;	    
	 // slave 2
	 axi_wresp_s2.BID = 4'b0;
	 axi_wresp_s2.BRESP = 2'b0;
	 axi_wresp_s2.BVALID = 1'b0;	    
      end // if (!clk_rst_if.rstn)      
      else begin
	 // slave 1
	 if (SEND_BRESP_s1 && axi_wresp_s1.BREADY) begin
	    axi_wresp_s1.BID = AWID_S1;
	    axi_wresp_s1.BRESP = 2'b0;
	    axi_wresp_s1.BVALID = 1'b1;	    
	 end
	 else begin
	    axi_wresp_s1.BID = 4'b0;
	    axi_wresp_s1.BRESP = 2'b0;
	    axi_wresp_s1.BVALID = 1'b0;	    	    
	 end
	 // slave 2
	 if (SEND_BRESP_s2 && axi_wresp_s2.BREADY) begin
	    axi_wresp_s2.BID = AWID_S2;
	    axi_wresp_s2.BRESP = 2'b0;
	    axi_wresp_s2.BVALID = 1'b1;	    
	 end
	 else begin
	    axi_wresp_s2.BID = 4'b0;
	    axi_wresp_s2.BRESP = 2'b0;
	    axi_wresp_s2.BVALID = 1'b0;	    	    
	 end
      end // else: !if(!clk_rst_if.rstn)
   end // always @ (posedge clk_rst_if.   	

   // ocp interface
   always @(posedge clk_rst_if.clk) begin
      if (!clk_rst_if.rstn) begin
	 ocp_if.MTagID      = 4'b0;
	 ocp_if.MAddr       = 32'b0;
	 ocp_if.MCmd        = 3'b0;
	 ocp_if.Mdata       = 32'b0;
	 ocp_if.MDataValid  = 1'b0;
	 ocp_if.MRespAccept = 1'b0;	 
      end // if (!clk_rst_if.rstn)      
      else begin
	 if (ARVALID_S1) begin
	    ocp_if.MTagID = ARID_S1;
	    ocp_if.MAddr  = ARADDR_S1;
	    ocp_if.MCmd   = 3'h0;
	 end
	 else if (ARVALID_S2) begin
	    ocp_if.MTagID = ARID_S2;
	    ocp_if.MAddr  = ARADDR_S2;
	    ocp_if.MCmd   = 3'h0;
	 end
	 else if (AWVALID_S1) begin
	    ocp_if.MTagID = AWID_S1;
	    ocp_if.MAddr  = AWADDR_S1;
	    ocp_if.MCmd   = 3'h1;
	 end
	 else if (AWVALID_S2) begin
	    ocp_if.MTagID = AWID_S2;
	    ocp_if.MAddr  = AWADDR_S2;
	    ocp_if.MCmd   = 3'h1;
	 end
	 else begin
	    ocp_if.MTagID      = 4'b0;
	    ocp_if.MAddr       = 32'b0;
	    ocp_if.MCmd        = 3'b0;	    
	 end	 

	 if (axi_wdata_s1.WVALID) begin
	    ocp_if.MDataValid  = 1'b1;
	    ocp_if.Mdata       = axi_wdata_s1.WDATA;	    
	 end
	 else if (axi_wdata_s2.WVALID) begin
	    ocp_if.MDataValid  = 1'b1;
	    ocp_if.Mdata       = axi_wdata_s2.WDATA;	    
	 end
	 else begin
	    ocp_if.Mdata       = 32'b0;
	    ocp_if.MDataValid  = 1'b0;
	 end

	 if (ocp_if.SResp != OCP_NULL)
	    ocp_if.MRespAccept = 1'b1;
	 else
	    ocp_if.MRespAccept = 1'b0;	   
	 
      end // else: !if(!clk_rst_if.rstn)
   end // always @ (posedge clk_rst_if.clk)
      
endmodule // interconnect


// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

interface clkrst_if;
   logic clk;   
   logic rstn;   

   modport source (output clk,
		   output rstn);

   modport sink (input clk,
		 input rstn);   

endinterface // clkrst_if

interface axi_waddr_if;
   logic [AXI_ADDR_WIDTH-1: 0] axi_awaddr;
   logic [3:0] 		       axi_awid;
   logic [3:0] 		       axi_awlen;
   logic [2:0] 		       axi_awsize;
   logic [3:0] 		       axi_awcache;
   logic [2:0] 		       axi_awprot;   
   logic 		       axi_awvalid;   
   logic 		       axi_awready;

   modport master (output axi_awaddr,
		   axi_awid, 
		   axi_awlen, 
		   axi_awsize, 
		   axi_awcache,
		   axi_awprot,
		   axi_awvalid,
		   input axi_awready);
   
   modport slave (input axi_awaddr,
		  axi_awid, 
		  axi_awlen, 
		  axi_awsize, 
		  axi_awcache,
		  axi_awprot,
		  axi_awvalid,
		  output axi_awready);
endinterface // axi_waddr_if

interface axi_wdata_if;
   logic [AXI_DATA_WIDTH-1: 0] axi_wdata;
   logic [3:0] 		       axi_wid;
   logic 		       axi_wlast;   
   logic 		       axi_wvalid;   
   logic 		       axi_wready;   

   modport master (output axi_wdata, 
		   axi_wid, 
		   axi_wlast, 
		   axi_wvalid,
		   input axi_wready);
   
   modport slave (input axi_wdata,
   		  axi_wid,    
		  axi_wlast,    
		  axi_wvalid,		  
		  output axi_wready);   		
endinterface // axi_wdata_if

interface axi_wresp_if;
   logic [3:0] 		 axi_bid;
   logic [1:0] 		 axi_bresp;
   logic 		 axi_bvalid;   
   logic 		 axi_bready;
   
   modport master (input axi_bid,
		   axi_bresp, 
		   axi_bvalid,
		   output axi_bready);
      
   modport slave (output axi_bid, 
		  axi_bresp, 
		  axi_bvalid,
		  input axi_bready);      
endinterface // axi_wresp_if

interface axi_raddr_if;
   logic [AXI_ADDR_WIDTH-1: 0] axi_araddr;
   logic [3:0] 		       axi_arid;
   logic [3:0] 		       axi_arlen;
   logic [2:0] 		       axi_arsize;
   logic [1:0] 		       axi_arburst;
   logic [1:0] 		       axi_arlock;
   logic [3:0] 		       axi_arcache;
   logic [2:0] 		       axi_arprot;   
   logic 		       axi_arvalid;   
   logic 		       axi_arready;   

   modport master (output axi_araddr, 
		   axi_arid, 
		   axi_arlen, 
		   axi_arsize, 
		   axi_arburst, 
		   axi_arlock, 
		   axi_arcache, 
		   axi_arprot, 
		   axi_arvalid,
		   input axi_arready);

   modport slave (input axi_araddr,  
		  axi_arid,    
		  axi_arlen,   
		  axi_arsize,  
		  axi_arburst, 
		  axi_arlock,  
		  axi_arcache, 
		  axi_arprot,  
		  axi_arvalid,
		  output axi_arready);   
endinterface // axi_raddr_if

interface axi_rdata_if;
   logic [AXI_DATA_WIDTH-1: 0] axi_rdata;
   logic [3:0] 		       axi_rid;
   logic [1:0] 		       axi_rresp;
   logic 		       axi_rlast;   
   logic 		       axi_rvalid;   
   logic 		       axi_rready;   

   modport master (output axi_rdata, 
		   axi_rid, 
		   axi_rresp, 
		   axi_rlast, 
		   axi_rvalid,
		   input axi_rready);   

   modport slave (input axi_rdata,    
		  axi_rid,      
		  axi_rresp,    
		  axi_rlast,    
		  axi_rvalid,
		  output axi_rready);   
endinterface // axi_rdata_if

interface ocp_if;
   logic [OCP_ADDR_WIDTH-1: 0] ocp_mAddr;
   logic [OCP_DATA_WIDTH-1: 0] ocp_mData;
   logic [2:0] 		       ocp_mCmd;
   logic [2:0] 		       ocp_mTagId;
   logic [3:0] 		       ocp_mBurstLength;
   logic                       ocp_mReqLast; 		       
   logic 		       ocp_mDataValid;
   logic 		       ocp_mRespAccept;
   logic 		       ocp_sCmdAccept;
   logic 		       ocp_sDataAccept;
   logic [OCP_DATA_WIDTH-1: 0] ocp_sData;
   logic [1:0]		       ocp_sResp;      
   
   modport master (output ocp_mAddr,      
		   ocp_mData,      
		   ocp_mCmd,       
		   ocp_mTagId,     
		   ocp_mDataValid, 
		   ocp_mRespAccept,
		   ocp_mBurstLength,
		   ocp_mReqLast,
		   input ocp_sCmdAccept, 
			 ocp_sDataAccept,
			 ocp_sData, 
			 ocp_sResp);

   modport slave (input ocp_mAddr,      
		   ocp_mData,      
		   ocp_mCmd,       
		   ocp_mTagId,     
		   ocp_mDataValid, 
		   ocp_mRespAccept,
		   ocp_mBurstLength,
		   ocp_mReqLast,		  
		   output ocp_sCmdAccept, 
			  ocp_sDataAccept,
			  ocp_sData, 
			  ocp_sResp);

endinterface // ocp_if



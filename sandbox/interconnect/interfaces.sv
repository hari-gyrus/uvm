// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// clk & reset interface
//

interface clk_rst_if;

   logic clk;
   logic rstn;

   modport src  ( output clk, rstn);   
   modport sink ( input  clk, rstn);   
		        
endinterface // clk_rstn_if

// axi read addr interface
interface axi_raddr_if #(AW = 32, DW = 32);

   logic [3:0]          ARID; 
   logic [AW-1:0] 	ARADDR;
   logic [3:0] 		ARLEN;
   logic [2:0] 		ARSIZE;
   logic [1:0] 		ARBURST;
   logic [1:0] 		ARLOCK;
   logic [3:0] 		ARCACHE;
   logic [2:0] 		ARPROT;
   logic 		ARVALID;   
   logic 		ARREADY;   

   modport master ( output ARID,
			   ARADDR,
			   ARLEN, 
			   ARSIZE,
			   ARBURST,
			   ARLOCK,
			   ARCACHE,
			   ARPROT,
			   ARVALID,
		    input  ARREADY);

   modport slave  ( input  ARID,
			   ARADDR,
			   ARLEN, 
			   ARSIZE,
			   ARBURST,
			   ARLOCK,
			   ARCACHE,
			   ARPROT,
			   ARVALID,
		    output ARREADY);
   
endinterface // axi_raddr_if

// axi read data interface
interface axi_rdata_if #(AW = 32, DW = 32);

   logic [3:0]		   RID;   
   logic [DW-1:0] 	   RDATA;
   logic [1:0] 		   RRESP;
   logic 		   RLAST;   
   logic 		   RVALID;   
   logic 		   RREADY;  
				
   modport master ( input  RID,
		           RDATA,
			   RRESP,
			   RLAST,
			   RVALID,
		    output RREADY);
   
   modport slave  ( output RID,
		           RDATA,
			   RRESP,
			   RLAST,
			   RVALID,
		    input  RREADY);

endinterface // axi_rdata_if

// axi write address interface
interface axi_waddr_if #(AW = 32, DW = 32);

   logic [3:0] 		   AWID;
   logic [AW-1:0] 	   AWADDR;
   logic [3:0] 		   AWLEN;
   logic [2:0] 		   AWSIZE;
   logic [3:0] 		   AWCACHE;
   logic [2:0] 		   AWPROT;
   logic 		   AWVALID;
   logic 		   AWREADY;

   modport master ( output AWID,
		    	   AWADDR, 
			   AWLEN,  
			   AWSIZE, 
			   AWCACHE,
			   AWPROT, 
			   AWVALID,
		    input  AWREADY);
   
   modport slave  ( input  AWID,
		    	   AWADDR, 
			   AWLEN,  
			   AWSIZE, 
			   AWCACHE,
			   AWPROT, 
			   AWVALID,
		    output AWREADY);
		    
endinterface // axi_waddr_if

// axi write data interface
interface axi_wdata_if #(AW = 32, DW = 32);

   logic [3:0]		   WID;   
   logic [DW-1:0] 	   WDATA;
   logic 		   WLAST;   
   logic 		   WVALID;   
   logic 		   WREADY;  
				
   modport master ( output  WID,
		            WDATA,
		            WLAST, 
			    WVALID,
		     input  WREADY);
   
   modport slave  ( input  WID,
		           WDATA,
			   WLAST,
			   WVALID,
		    output WREADY);

endinterface // axi_wdata_if

// axi write resp interface
interface axi_wresp_if;

   logic [3:0]		   BID;   
   logic [1:0] 		   BRESP;
   logic 		   BVALID;   
   logic 		   BREADY;  
				
   modport master ( input  BID,
			   BRESP,
			   BVALID,
		    output BREADY);
   
   modport slave  ( output BID,
			   BRESP,
			   BVALID,
		    input  BREADY);

endinterface // axi_wresp_if

// ocp interface
interface ocp_if #(AW = 32, DW = 32);

   logic [3:0] 		MTagID;     
   logic [AW-1:0]       MAddr;
   logic [2:0]          MCmd; 
   logic [DW-1:0] 	Mdata;   
   logic 		MDataValid;   
   logic 		MRespAccept;   
   logic 		SCmdAccept;   
   logic [DW-1:0] 	Sdata;   
   logic 		SDataAccept;
   logic [1:0] 		SResp;

   modport master ( output MTagID,
		           MAddr,      
			   MCmd,       
			   Mdata,      
			   MDataValid, 
		           MRespAccept,
		   input   SCmdAccept, 
			   Sdata,      
			   SDataAccept,
			   SResp);

   modport slave ( input   MTagID,
		           MAddr,      
			   MCmd,       
			   Mdata,      
			   MDataValid, 
		           MRespAccept,
		   output  SCmdAccept, 
			   Sdata,      
			   SDataAccept,
			   SResp);

endinterface // ocp_if


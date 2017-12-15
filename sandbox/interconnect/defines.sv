// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

`ifndef INCLUDE_DEFINES__

 `define INCLUDE_DEFINES__

parameter AW = 32;
parameter DW = 32;

typedef enum bit [1:0] { RRESP_OKAY   = 2'b00,
			 RRESP_EXOKAY = 2'b01,
			 RRESP_SLVERR = 2'b10,
			 RRESP_DECERR = 2'b11 
			 } RRESP_T;

typedef enum bit [1:0] { BRESP_OKAY   = 2'b00,
			 BRESP_EXOKAY = 2'b01,
			 BRESP_SLVERR = 2'b10,
			 BRESP_DECERR = 2'b11 
			 } BRESP_T;

typedef enum bit [2:0] { IDLE    = 3'b000,  // IDLE
			 WRITE   = 3'b001,  // WRITE
			 READ    = 3'b010,  // READ
			 READEX  = 3'b011,  // READ EXCLUSIVE
			 RDL     = 3'b100,  // READ LINKED
			 WRNP    = 3'b101,  // WRITE NON POSTED
			 WRC     = 3'b110,  // WRITE CONDITIONAL
			 BCAST   = 3'b111   // BROADCAST
			 } MCmd_T;

typedef enum bit [1:0] { NULL = 2'b00, // NO RESPONSE
			 DVA  = 2'b01, // DATA VALID / ACCEPT
			 FAIL = 2'b10, // REQUEST FAILED
			 ERR  = 2'b11  // RESPONSE ERROR
			 } SResp_T;


`endif

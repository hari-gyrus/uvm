// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

parameter AXI_READ  = 0;
parameter AXI_WRITE = 1;

parameter AXI_ADDR_WIDTH = 32;
parameter AXI_DATA_WIDTH = 32;

parameter OCP_READ  = 0;
parameter OCP_WRITE = 1;

parameter OCP_ADDR_WIDTH = 32;
parameter OCP_DATA_WIDTH = 32;

typedef enum { READ = 0, WRITE = 1 } rd_wr_type_t;

typedef enum logic [2:0] {
			  IDLE = 'b000,
			  WR   = 'b001,
			  RD   = 'b010,
			  RDEX = 'b011,
			  RDL  = 'b100,
			  WRNP = 'b101,
			  WRC  = 'b110,
			  BCST = 'b111
			  } ocp_mcmd_type_t;


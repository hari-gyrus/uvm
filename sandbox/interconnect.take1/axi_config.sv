// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// axi config
//

class axi_config extends uvm_object;

   // dut virtual interface
   virtual clkrst_if clkrst_vif;   
   virtual axi_waddr_if axi_waddr_vif;
   virtual axi_wdata_if axi_wdata_vif;
   virtual axi_wresp_if axi_wresp_vif;
   virtual axi_raddr_if axi_raddr_vif;
   virtual axi_rdata_if axi_rdata_vif;
   
endclass // axi_config


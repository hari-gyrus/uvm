// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

//
// ocp config 
//

class ocp_config extends uvm_object;
   // dut virtual interface
   virtual ocp_if ocp_vif;   
   virtual clkrst_if clkrst_vif;   
endclass // ocp_config

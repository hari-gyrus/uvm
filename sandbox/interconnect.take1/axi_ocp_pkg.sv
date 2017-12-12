// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

`ifndef AXI_OCP_UVM_PKG
 `define AXI_OCP_UVM_PKG

package axi_ocp_pkg;
   import uvm_pkg::*;
 
 `include "defines.svh"

 `include "ocp_config.sv"
 `include "axi_config.sv"
 `include "cyclic_random_id.sv"
   
 `include "axi_transaction.sv"
 `include "ocp_transaction.sv"
 `include "axi_master_simple_sequence.sv"
 `include "ocp_slave_simple_sequence.sv"
  
 `include "axi_master_driver.sv"
 `include "axi_master_monitor.sv"
 `include "axi_master_sequencer.sv"   
 `include "axi_master_agent.sv"

 `include "ocp_slave_driver.sv"
 `include "ocp_slave_monitor.sv"
 `include "ocp_slave_sequencer.sv"
 `include "ocp_slave_agent.sv"
      
 `include "inorder_scoreboard.sv"
 `include "interconnect_env.sv"   

endpackage // axi_ocp_pkg
   
`endif

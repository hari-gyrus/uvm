// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class alive_test extends uvm_test;
   `uvm_component_utils(alive_test)

   // sub components - env, sequence
/* -----\/----- EXCLUDED -----\/-----
   test_env env;   
   ocp_sequence ocp_seq;   
   axi_sequence axi_seq1, axi_seq2;   
 -----/\----- EXCLUDED -----/\----- */
   
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);

      // factory create
/* -----\/----- EXCLUDED -----\/-----
      env      = test_env::typeid::create("env", this);
      ocp_seq  = ocp_sequence::typeid::create("ocp_seq", this);
      axi_seq1 = ocp_sequence::typeid::create("ocp_seq1", this);
      axi_seq2 = ocp_sequence::typeid::create("ocp_seq2", this);      
 -----/\----- EXCLUDED -----/\----- */

      // 
   endfunction // build_phase
   
   
endclass // alive_test

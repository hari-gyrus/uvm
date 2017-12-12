// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class alive_test extends uvm_test;
   `uvm_component_utils(alive_test)

   import axi_ocp_pkg::*;
   
   interconnect_env simple_env;
   ocp_slave_simple_sequence ocp_seq;   
   axi_master_simple_sequence axi_seq1, axi_seq2;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      simple_env = interconnect_env::type_id::create("simple_env", this);      
   endfunction // build_phase   

   function void end_of_elaboration_phase (uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      //uvm_top.set_verbosity_level_hier (UVM_MEDIUM);
      this.print();      
   endfunction // end_of_elaboration_phase
   
   task run_phase(uvm_phase phase);
      `uvm_info("run_phase", "Raising the objection & starting the test", UVM_MEDIUM)
      phase.raise_objection(this, "Starting the test function");      

      ocp_seq  = ocp_slave_simple_sequence::type_id::create("ocp_slave_simple_sequence");
      axi_seq1 = axi_master_simple_sequence::type_id::create("axi_master_simple_sequence1");
      axi_seq2 = axi_master_simple_sequence::type_id::create("axi_master_simple_sequence2");

      axi_seq1.master_id = 0;
      axi_seq2.master_id = 1;

      axi_seq1.num_transactions = 5;
      axi_seq2.num_transactions = 5;
      ocp_seq.num_transactions = 5;

      fork
	 axi_seq1.start(simple_env.axi_m1.axi_seq);
	 ocp_seq.start(simple_env.ocp_s1.ocp_seq);	 
      join      
      
      phase.drop_objection(this, "Ending the test");      
   endtask // run_phase
   
endclass // alive_test

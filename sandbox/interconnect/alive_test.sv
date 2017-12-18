// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class alive_test extends uvm_test;
   `uvm_component_utils(alive_test)

   // sub components - config, env, sequence
   test_env env;
   ocp_sequence ocp_s1_sequence;
   axi_sequence axi_m1_sequence, axi_m2_sequence;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);

      // factory create 
      env = test_env::typeid::create("env", this);
   endfunction // build_phase

   virtual function void end_of_elaboration(uvm_phase phase);
      super.end_of_elaboration(phase);
      this.print();      
   endfunction // end_of_elaboration   
     
   task run_phase(uvm_phase phase);
      ocp_s1_sequence = ocp_sequence::typeid::create("ocp_s1_sequence",  this);
      axi_m1_sequence = axi_sequence::typeid::create("axi_m1_sequence", this);
      axi_m2_sequence = axi_sequence::typeid::create("axi_m2_sequence", this);

      axi_m1_sequence.master_id = 1;
      axi_m1_sequence.num_transactions = 10;      
      
      axi_m2_sequence.master_id = 2;
      axi_m2_sequence.num_transactions = 10;     
      
      phase.raise_objection(this, "Starting test");
      fork
	 ocp_s1_sequence.start(env.ocp_agent.ocp_s1_sequencer);
	 axi_m1_sequence.start(env.axi_agent1.axi_sequencer);
	 axi_m2_sequence.start(env.axi_agent2.axi_sequencer);	 
      join_none     
      phase.drop_objection(this, "Ending test");      
   endtask // run_phase
   
endclass // alive_test

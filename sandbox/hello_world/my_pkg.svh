
package my_pkg;

   import uvm_pkg::*;
   
   class my_env extends uvm_env;
      `uvm_component_utils(my_env)
      
      function new (string name, uvm_component parent);
	 super.new(name, parent);      
      endfunction // new   
   endclass // my_env

   class hello_world extends uvm_test;
      `uvm_component_utils(hello_world)
      
      my_env m_env;
      
      function new (string name, uvm_component parent);
	 super.new(name, parent);      
      endfunction // new   
      
      function void build_phase(uvm_phase phase);
	 m_env = my_env::type_id::create("m_env", this);
      endfunction // build_phase      
      
      task run_phase(uvm_phase phase);
	 phase.raise_objection(this);
	 `uvm_info("", "Hello World !!", UVM_MEDIUM)	 
 	 phase.drop_objection(this);	 
      endtask // run_phase      
   endclass // hello_world
      
endpackage // my_pkg
   

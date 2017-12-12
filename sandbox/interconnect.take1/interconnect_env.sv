// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class interconnect_env extends uvm_env;
   `uvm_component_utils(interconnect_env)

   // env sub components: master & slave agents, config, scoreboard
   ocp_slave_agent ocp_s1;
   axi_master_agent axi_m1, axi_m2;

   ocp_config ocp_cfg;   
   axi_config axi_cfg1, axi_cfg2;

   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_ocp_wr_sb1;   
   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_ocp_wr_sb2;   
   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_ocp_rd_sb1;   
   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_ocp_rd_sb2;   
   
   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   // build_phase
   //   1. create sub components
   //   2. get config
   //   3. assign config

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      
      // 1. create sub components: use factory to create master & slave agents, scoreboard
      axi_m1 = axi_master_agent::type_id::create("axi_m1", this);
      axi_m2 = axi_master_agent::type_id::create("axi_m2", this);      
      ocp_s1 = ocp_slave_agent::type_id::create("ocp_s1", this);      

      axi_ocp_wr_sb1 = inorder_scoreboard::type_id::create("axi_ocp_wr_sb1", this);      
      axi_ocp_rd_sb1 = inorder_scoreboard::type_id::create("axi_ocp_rd_sb1", this);      
      axi_ocp_wr_sb2 = inorder_scoreboard::type_id::create("axi_ocp_wr_sb2", this);      
      axi_ocp_rd_sb2 = inorder_scoreboard::type_id::create("axi_ocp_rd_sb2", this);      

      // 2. get config
      if (!uvm_config_db #(axi_config)::get(this, "", "axi_cfg1", axi_cfg1)) begin
	 `uvm_fatal("NO_CONFIG", {"Unable to retrieve configuration for: ", get_full_name()})
      end            

      if (!uvm_config_db #(axi_config)::get(this, "", "axi_cfg2", axi_cfg2)) begin
	 `uvm_fatal("NO_CONFIG", {"Unable to retrieve configuration for: ", get_full_name()})
      end            

      if (!uvm_config_db #(ocp_config)::get(this, "", "ocp_cfg", ocp_cfg)) begin
	 `uvm_fatal("NO_CONFIG", {"Unable to retrieve configuration for: ", get_full_name()})
      end            

      // 3. assign config
      ocp_s1.ocp_cfg = ocp_cfg;      
      axi_m1.axi_cfg = axi_cfg1;
      axi_m2.axi_cfg = axi_cfg2;            
      
   endfunction // build_new

   // connect_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      axi_m1.axi_wr_aport.connect(axi_ocp_wr_sb1.req_an_export);
      axi_m1.axi_rd_aport.connect(axi_ocp_rd_sb1.req_an_export);
      axi_m2.axi_wr_aport.connect(axi_ocp_wr_sb2.req_an_export);
      axi_m2.axi_rd_aport.connect(axi_ocp_rd_sb2.req_an_export);            

   endfunction // connect_phase

   // run_phase - dummy
   task run_phase(uvm_phase phase);      
   endtask // run_phase
   
endclass // interconnect_env




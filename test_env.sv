// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class test_env extends uvm_env;
   `uvm_component_utils(test_env)

   // sub components - config, agents, scoreboard
   ocp_config ocp_s1_cfg;
   axi_config axi_m1_cfg, axi_m2_cfg;

   ocp_slave_agent ocp_s1_agent;
   axi_master_agent axi_m1_agent, axi_m2_agent;

   inorder_scoreboard axi_m1_rd_sb;
   inorder_scoreboard axi_m1_wr_sb;   
   inorder_scoreboard axi_m2_rd_sb;
   inorder_scoreboard axi_m2_wr_sb;   
         
   function new (string name, uvm_component parent);
      super.new(string, parent);      
   endfunction // new

   virtual function viod build_phase (uvm_phase phase);

      ocp_s1_cfg = new();
      axi_m1_cfg = new();
      axi_m2_cfg = new();

      ocp_s1_agent = ocp_slave_agent::typeid::create("ocp_s1_agent", this);
      axi_m1_agent = axi_master_agent::typeid::create("axi_m1_agent", this);
      axi_m2_agent = axi_master_agent::typeid::creare("axi_m2_agent", this);

      axi_m1_rd_sb = inorder_scoreboard::typeid::create("axi_m1_rd_sb", this);
      axi_m1_wr_sb = inorder_scoreboard::typeid::create("axi_m1_wr_sb", this);
      axi_m2_rd_sb = inorder_scoreboard::typeid::create("axi_m2_rd_sb", this);
      axi_m2_rd_sb = inorder_scoreboard::typeid::create("axi_m2_wr_sb", this);      

      uvm_config_db #(ocp_config)::get::(this, "", "ocp_s1_cfg", ocp_s1_cfg);
      uvm_config_db #(axi_config)::get::(this, "", "axi_m1_cff", axi_m1_cfg);
      uvm_config_db #(axi_config)::get::(this, "", "axi_m2_cfg", axi_m2_cfg);

      ocp_s1_agent.ocp_cfg = ocp_s1_cfg;
      axi_m1_agent.axi_cfg = axi_m1_cfg;
      axi_m2_agent.axi_cfg = axi_m2_cfg;      

   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);

      axi_m1_agent.rd_analysis_port(axi_m1_rd_sb.rd_analysis_export);
      axi_m1_agent.wr_analysis_port(axi_m1_wr_sb.wr_analysis_export);
      axi_m2_agent.rd_analysis_port(axi_m2_rd_sb.rd_analysis_export);
      axi_m2_agent.wr_analysis_port(axi_m2_wr_sb.wr_analysis_export);      

   endfunction // connect_phase            
   
endclass // test_env

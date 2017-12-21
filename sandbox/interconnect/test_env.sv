// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class test_env extends uvm_env;
   `uvm_component_utils(test_env)

   ocp_config ocp_s1_cfg;
   axi_config axi_m1_cfg, axi_m2_cfg;
   
   ocp_slave_agent ocp_s1_agent;
   axi_master_agent axi_m1_agent, axi_m2_agent;

   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_m1_ocp_wr_sb;
   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_m1_ocp_rd_sb;
   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_m2_ocp_rd_sb;
   inorder_scoreboard #(axi_transaction, ocp_transaction) axi_m2_ocp_wr_sb;
         
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      
      ocp_s1_agent = ocp_slave_agent::type_id::create("ocp_s1_agent", this);
      axi_m1_agent = axi_master_agent::type_id::create("axi_m1_agent", this);
      axi_m2_agent = axi_master_agent::type_id::create("axi_m2_agent", this);

      axi_m1_ocp_wr_sb = inorder_scoreboard#(axi_transaction, ocp_transaction)::type_id::create("axi_m1_ocp_wr_sb", this);
      axi_m1_ocp_rd_sb = inorder_scoreboard#(axi_transaction, ocp_transaction)::type_id::create("axi_m1_ocp_rd_sb", this);
      axi_m2_ocp_rd_sb = inorder_scoreboard#(axi_transaction, ocp_transaction)::type_id::create("axi_m2_ocp_rd_sb", this);
      axi_m2_ocp_wr_sb = inorder_scoreboard#(axi_transaction, ocp_transaction)::type_id::create("axi_m2_ocp_wr_sb", this);

      if (!uvm_config_db #(ocp_config)::get(this, "", "ocp_s1_cfg", ocp_s1_cfg))
	`uvm_fatal("UVM_CFG_ERR", {"Unable to retrieve config for: ", get_full_name()});      
      
      if(!uvm_config_db #(axi_config)::get(this, "", "axi_m1_cfg", axi_m1_cfg))
	`uvm_fatal("UVM_CFG_ERR", {"Unable to retrieve config for: ", get_full_name()});      
      
      if(!uvm_config_db #(axi_config)::get(this, "", "axi_m2_cfg", axi_m2_cfg))
	`uvm_fatal("UVM_CFG_ERR", {"Unable to retrieve config for: ", get_full_name()});      
      
      ocp_s1_agent.ocp_cfg = ocp_s1_cfg;
      axi_m1_agent.axi_cfg = axi_m1_cfg;
      axi_m2_agent.axi_cfg = axi_m2_cfg;
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);      

      axi_m1_agent.wr_ana_port.connect(axi_m1_ocp_wr_sb.req_ana_export);
      ocp_s1_agent.wr_ana_port.connect(axi_m1_ocp_wr_sb.resp_ana_export);      
      axi_m1_agent.rd_ana_port.connect(axi_m1_ocp_rd_sb.req_ana_export);
      ocp_s1_agent.rd_ana_port.connect(axi_m1_ocp_rd_sb.resp_ana_export);      

      axi_m2_agent.wr_ana_port.connect(axi_m2_ocp_wr_sb.req_ana_export);
      ocp_s1_agent.wr_ana_port.connect(axi_m2_ocp_wr_sb.resp_ana_export);    
      axi_m2_agent.rd_ana_port.connect(axi_m2_ocp_rd_sb.req_ana_export);
      ocp_s1_agent.rd_ana_port.connect(axi_m2_ocp_rd_sb.resp_ana_export);      
   endfunction // connect_phase            

   task run_phase(uvm_phase phase);
   endtask // run_phase

endclass // test_env

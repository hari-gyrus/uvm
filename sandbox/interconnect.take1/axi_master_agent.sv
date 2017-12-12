// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_master_agent extends uvm_agent #(axi_transaction);
   `uvm_component_utils(axi_master_agent)

   // agent sub components: config, seq, drv, monitor
   axi_config axi_cfg;
   axi_master_driver axi_drv;
   axi_master_monitor axi_mon;
   axi_master_sequencer axi_seq;

   // agent analysis ports (connect to sb at env)
   uvm_analysis_port #(axi_transaction) axi_wr_aport;
   uvm_analysis_port #(axi_transaction) axi_rd_aport;   

   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   // build_phase
   //   1. create sub components
   //   2. create analysis ports
   //   3. set driver config
   //   4. set monitor config

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      // 1. create sub components: use factory to create seq, drv, mon
      axi_drv = axi_master_driver::type_id::create("axi_drv", this);
      axi_mon = axi_master_monitor::type_id::create("axi_mon", this);
      axi_seq = axi_master_sequencer::type_id::create("axi_seq", this);

      // 2. create analysis ports: use new (dont need factory override)
      axi_wr_aport = new("axi_wr_aport", this);
      axi_rd_aport = new("axi_rd_aport", this);     
		    
      // 3. set driver config: axi master driver to retrieve using get
      axi_drv.axi_cfg = axi_cfg;
      
      // 4. set monitor config: axi master monitor to retrieve using get
      axi_mon.axi_cfg = axi_cfg;

   endfunction // build_phase

   // connect_phase
   //   1. connect drv <-> seq port/export
   //   2. connect mon <-> agent analysis ports
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      // 1. connect drv <-> seq port/export: uvm built in mechanism - port/export
      axi_drv.seq_item_port.connect(axi_seq.seq_item_export);

      // 2. connect mon <-> agent analysis ports: will connect to sb in env
      axi_mon.axi_wr_aport.connect(axi_wr_aport);
      axi_mon.axi_rd_aport.connect(axi_rd_aport);

   endfunction // connect_phase   

   // run_phase : dummy for agent
   task run_phase(uvm_phase phase);
   endtask // run_phase
   
endclass // axi_master_agent



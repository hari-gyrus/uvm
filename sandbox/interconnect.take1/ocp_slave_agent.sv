// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_agent extends uvm_agent #(ocp_transaction);
   `uvm_component_utils(ocp_slave_agent)

   // agent sub components: config, seq, drv, monitor
   ocp_config ocp_cfg;   
   ocp_slave_driver ocp_drv;
   ocp_slave_monitor ocp_mon;
   ocp_slave_sequencer ocp_seq;

   // agent analysis ports (connect to sb at env)
   uvm_analysis_port #(ocp_transaction) ocp_wr_aport;
   uvm_analysis_port #(ocp_transaction) ocp_rd_aport;   
   
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

      // 1. create sub components: use factory  to create seq, drv, mon
      ocp_drv = ocp_slave_driver::type_id::create("ocp_drv", this);
      ocp_mon = ocp_slave_monitor::type_id::create("ocp_mon", this);
      ocp_seq = ocp_slave_sequencer::type_id::create("ocp_seq", this);

      // 2. create analysis ports: use new (dont need factory override)
      ocp_wr_aport = new("ocp_wr_aport", this);
      ocp_rd_aport = new("ocp_rd_aport", this);     
		    
      // 3. set driver config: ocp slave driver to retrieve using get
      ocp_drv.ocp_cfg = ocp_cfg;      

      // 4. set monitor config: ocp slave monitor to retrieve using get
      ocp_mon.ocp_cfg = ocp_cfg;      

   endfunction // build_phase

   // connect_phase
   //   1. connect drv <-> seq port/export
   //   2. connect mon <-> agent analysis ports
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);      
      
      // 1. connect drv <-> seq port/export: uvm built in mechanism - port/export
      ocp_drv.seq_item_port.connect(ocp_seq.seq_item_export);

      // 2. connect mon <-> agent analysis ports: will connect to sb in env
      ocp_mon.ocp_wr_aport.connect(ocp_wr_aport);
      ocp_mon.ocp_rd_aport.connect(ocp_rd_aport);
      
   endfunction // connect_phase   

   // run_phase : dummy for agent
   task run_phase(uvm_phase phase);
   endtask // run_phase
   
endclass // ocp_slave_agent



// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_agent extends uvm_agent;
   `uvm_component_utils(ocp_agent)

   ocp_config ocp_cfg;   
   ocp_slave_drive ocp_drv;
   ocp_slave_sequencer ocp_seq;
   ocp_slave_monitor ocp_mon;

   uvm_analysis_port #(ocp_transaction) rd_ana_port;
   uvm_analysis_port #(ocp_transaction) wr_ana_port;   

   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function viod build_phase(uvm_phase phase);
      super.build_phase(phase);

      ocp_cfg = new();      
      ocp_drv = ocp_slave_drive::typeid::create(ocp_drv, this);
      ocp_seq = ocp_slave_sequencer::typeid::create(ocp_seq, this);
      ocp_mon = ocp_slave_monitor::typeid::create(ocp_mon, this);

      ocp_drv.ocp_cfg = ocp_cfg;
      ocp_mon.ocp_cfg = ocp_cfg;            
   endfunction //

   virtual function void connect_phase(uvm_phase phase);
      ocp_drv.seq_item_port(ocp_seq.seq_item_export);
      ocp_mon.rd_ana_port.connect(rd_ana_port);
      ocp_mon.wr_ana_port.connect(wr_ana_port);      
   endfunction // connect_phase   
endclass // ocp_agent

// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_agent extends uvm_agent;   
   `uvm_component_utils(ocp_slave_agent)

   ocp_config ocp_cfg;   
   ocp_slave_driver ocp_drv;
   ocp_slave_monitor ocp_mon;
   ocp_slave_sequencer ocp_seq;

   uvm_analysis_port #(ocp_transaction) rd_ana_port;
   uvm_analysis_port #(ocp_transaction) wr_ana_port;   

   function new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      ocp_drv = ocp_slave_driver::type_id::create("ocp_drv", this);
      ocp_mon = ocp_slave_monitor::type_id::create("ocp_mon", this);
      ocp_seq = ocp_slave_sequencer::type_id::create("ocp_seq", this);

      rd_ana_port = new("rd_ana_port", this);
      wr_ana_port = new("wr_ana_port", this);
      
      ocp_drv.ocp_cfg = ocp_cfg;
      ocp_mon.ocp_cfg = ocp_cfg;            
   endfunction // build_phase   

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);      
      ocp_mon.rd_ana_port.connect(rd_ana_port);
      ocp_mon.wr_ana_port.connect(wr_ana_port);      
      ocp_drv.seq_item_port.connect(ocp_seq.seq_item_export);
   endfunction // connect_phase   

endclass // ocp_agent

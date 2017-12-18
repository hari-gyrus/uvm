// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_master_agent extends uvm_agent;
   `uvm_component_utils(axi_master_agent)

   axi_config axi_cfg;
   axi_driver axi_drv;
   axi_sequencer axi_seq;
   axi_monitor axi_mon;

   uvm_analysis_port rd_ana_port;
   uvm_analysis_port wr_ana_port;   
     
   function void new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtul function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      axi_cfg = new();
      rd_ana_port = new("rd_ana_port", this);
      wr_ana_port = new("wr_ana_port", this);      
      axi_drv = axi_driver::typeid::create(axi_drv, this);
      axi_seq = axi_sequencer::typeid::create(axi_seq, this);
      axi_mon = axi_monitor::typeid::create(axi_mon,this);

      axi_drv.axi_cfg = axi_cfg;
      axi_mon.axi_cfg = axi_cfg;      
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      axi_drv.seq_item_port.connect(axi_seq.seq_item_export);
      axi_mon.rd_ana_port.connect(rd_ana_port);
      axi_mon.wr_ana_port.connect(wr_ana_port);      
   endfunction // connect_phase
   
endclass // axi_master_agent
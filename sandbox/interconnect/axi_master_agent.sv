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
   axi_master_driver axi_drv;
   axi_master_monitor axi_mon;
   axi_master_sequencer axi_seq;
   
   uvm_analysis_port #(axi_transaction) rd_ana_port;
   uvm_analysis_port #(axi_transaction) wr_ana_port;   
     
   function new(string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      rd_ana_port = new("rd_ana_port", this);
      wr_ana_port = new("wr_ana_port", this);      
      axi_drv = axi_master_driver::type_id::create("axi_drv", this);
      axi_mon = axi_master_monitor::type_id::create("axi_mon", this);
      axi_seq = axi_master_sequencer::type_id::create("axi_seq", this);

      axi_drv.axi_cfg = axi_cfg;
      axi_mon.axi_cfg = axi_cfg;      
   endfunction // build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);      
      axi_mon.rd_ana_port.connect(rd_ana_port);
      axi_mon.wr_ana_port.connect(wr_ana_port);      
      axi_drv.seq_item_port.connect(axi_seq.seq_item_export);
   endfunction // connect_phase
   
endclass // axi_master_agent

// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_transaction extends uvm_sequence_item;
   `uvm_object_utils(ocp_transaction)

   import tb_pkg::*;
   
   rand MCmd_T cmd;   
   rand bit [2:0] id;
   rand bit [3:0] length;
   rand bit [AW-1:0] addr;
   rand bit [DW-1:0] data;   
   
   function new (string name);
      super.new(name);      
   endfunction // new

   function void do_copy(uvm_object rhs);
      int i;      
      ocp_transaction rhs_t;
      rhs_t = new();
      super.do_copy(rhs_t);

      this.id     = rhs.id;
      this.cmd    = rhs.cmd;
      this.length = rhs.length;
      this.addr   = rhs.addr;
      
      for (i=0; i<this.length; ++i)
	this.data[i] = rhs.data[i];      	
   endfunction // do_copy

   function string convert2string();
      string rpt;
      rpt = super.convert2string();

      $sformat(rpt, "id=%d cmd=%s addr=%h", this.id, this.cmd, this.addr);
      for (i=0; i<this.length; ++i)
	$sformat(rpt, "data[%d]=%h", i, data[i]);

      return rpt;      
   endfunction // convert2string

   function do_print(uvm_printer printer);
      printer.m_string = convert2string();      
   endfunction // do_print
   
endclass // ocp_transaction

// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_transaction extends uvm_sequence_item;
   `uvm_object_utils(axi_transaction)

   rand rw_T rw;   
   rand bit [3:0] id;
   rand bit [3:0] length;
   rand bit [AW-1:0] addr;
   rand bit [DW-1:0] data;   
   
   function new (string name = "axi_transaction");
      super.new(name);      
   endfunction // new
   
   function void do_copy(uvm_object rhs);
      int i;
      axi_transaction rhs_t;

      $cast(rhs_t, rhs);
      super.do_copy(rhs_t);
      
      id     = rhs_t.id;
      length = rhs_t.length;
      addr   = rhs_t.addr;

      for (i=0; i<length; ++i)
	data[i] = rhs_t.data[i];            
   endfunction // do_copy

   function string convert2string();
      int i;      
      string rpt;
      rpt = super.convert2string();

      $sformat(rpt, "id=%d rw=%s addr=%h", id, rw, addr);
      for (i=0; i<length; ++i)
	$sformat(rpt, "data[%d]=%h", i, data[i]);      

      return rpt;      
   endfunction // convert2string

   function void do_print(uvm_printer printer);
      printer.m_string = convert2string();      
   endfunction // do_print
   
endclass // axi_transaction

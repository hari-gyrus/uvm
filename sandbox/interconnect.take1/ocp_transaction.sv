// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

// ocp_transaction
//    1. random data items
//    2. new function
//    3. do_copy function
//    4. convert2string function
//    5. do_print function

class ocp_transaction extends uvm_sequence_item;
   `uvm_object_utils(ocp_transaction)   
   
   import axi_ocp_pkg::*;

   //    1. random data items
   rand ocp_mcmd_type_t cmd;  
   rand bit [3:0]  id;
   rand bit [3:0]  length;
   rand bit [31:0] addr;
   rand bit [31:0] data[];   

   //    2. new function
   function new (string name = "ocp_txn");
      super.new(name);      
   endfunction // new

   //    3. do_copy function
   function void do_copy(uvm_object rhs);
      ocp_transaction rhs_t;

      rhs_t = new();
      
      if (!$cast(rhs_t, rhs))
	`uvm_error ("do_copy", "Error casting rhs_t txn -> rhs OCP txn failed");

      super.do_copy(rhs_t);

      this.cmd    = rhs_t.cmd;
      this.id     = rhs_t.id;
      this.length = rhs_t.length;
      this.addr   = rhs_t.addr;
      this.data   = new[this.length];

      for (int i=0; i<this.length; ++i) begin
	 this.data[i] = rhs_t.data[i];	 
      end
		
   endfunction // do_copy
   
   //    4. convert2string function
   function string convert2string();
      string rpt;

      rpt = super.convert2string();
      $sformat(rpt, "%s: cmd=%s addr=%s id=%s length=%s", rpt, cmd.name, addr, id, length);
      for (int i; i<length; ++i) begin
	 $sformat(rpt, "%s: data[%s]=%s", rpt, i, data[i]);	 
      end            

      return rpt;      
   endfunction // convert2string   

   //    5. do_print function
   function void do_print(uvm_printer printer);
      printer.m_string = convert2string();      
   endfunction // do_print
   
endclass // ocp_transaction


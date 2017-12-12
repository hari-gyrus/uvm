// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

// axi_transaction
//    1. random data items
//    2. random constraints
//    3. new function
//    4. do_copy function
//    5. convert2string function
//    6. do_print function

class axi_transaction extends uvm_sequence_item;
   `uvm_object_utils(axi_transaction)   
   
   import axi_ocp_pkg::*;
   
   //    1. random data items
   rand bit [3:0]  id;
   rand bit [3:0]  length;
   rand bit [31:0] addr;
   rand bit [31:0] data[];     
   rand rd_wr_type_t rw;

   //    2. random constraints
   constraint data_length_c {
      data.size() == length;
      length >= 1;
   }
     
   //    3. new function
   function new (string name = "axi_txn");
      super.new(name);      
   endfunction // new

   //    4. do_copy function
   function void do_copy(uvm_object rhs);
      axi_transaction rhs_t;

      rhs_t = new();
      
      if (!$cast(rhs_t, rhs))
	`uvm_error ("do_copy", "Error casting rhs_t txn -> rhs AXI txn failed");

      super.do_copy(rhs_t);

      this.rw     = rhs_t.rw;
      this.id     = rhs_t.id;
      this.length = rhs_t.length;
      this.addr   = rhs_t.addr;
      this.data   = new[this.length];

      for (int i=0; i<this.length; ++i) begin
	 this.data[i] = rhs_t.data[i];	 
      end
		
   endfunction // do_copy
   
   //    5. convert2string function
   function string convert2string();
      string rpt;

      rpt = super.convert2string();
      $sformat(rpt, "%s: rw=%s addr=%s id=%s length=%s", rpt, rw.name, addr, id, length);
      for (int i; i<length; ++i) begin
	 $sformat(rpt, "%s: data[%s]=%s", rpt, i, data[i]);	 
      end            

      return rpt;      
   endfunction // convert2string   

   //    6. do_print function
   function void do_print(uvm_printer printer);
      printer.m_string = convert2string();      
   endfunction // do_print
   
endclass // axi_transaction


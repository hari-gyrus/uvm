// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_slave_simple_sequence extends uvm_sequence #(ocp_transaction);
   `uvm_object_utils(ocp_slave_simple_sequence)

   int num_transactions = 0;
   
   function new (string name = "");
      super.new(name);
   endfunction // new
   
   task body ();
      string ocp_txn_name;      
      ocp_transaction ocp_txn;

      ocp_txn = new();
      
      for (int i = 0; i < num_transactions; ++i) begin
	 ocp_txn_name = $psprintf("ocp_txn_%d", i);	 
	 ocp_txn = ocp_transaction::type_id::create(ocp_txn_name);
	 start_item(ocp_txn);	 
	 finish_item(ocp_txn);	 	 
	 `uvm_info("body", $psprintf("Sending OCP transaction: %s", ocp_txn.convert2string()), UVM_MEDIUM)
      end
      
   endtask // body
   
endclass // ocp_slave_simple_sequence


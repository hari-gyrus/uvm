// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class ocp_sequence extends uvm_sequence #(ocp_transaction);
   `uvm_object_utils(ocp_sequence)
   
   int num_transactions = 5;  

   function new (string name = "ocp_sequence");
      super.new(name);      
   endfunction // new

   task body();
      int i;
      ocp_transaction ocp_tx;
      
      for (i=0; i<num_transactions; ++i) begin
	 ocp_tx = new();

	 ocp_tx.randomize();
	 start_item(ocp_tx);
	 finish_item(ocp_tx);	   
      end      
   endtask // body

endclass // ocp_sequence

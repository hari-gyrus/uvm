// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_sequence extends uvm_sequence #(axi_transaction);
   `uvm_object_utils(axi_sequence)
   
   int master_id = 0;   
   int num_transactions = 5;
   
   function new (string name = "axi_sequence");
      super.new(name);      
   endfunction // new

   task body();
      int i;
      axi_transaction axi_txn;
      cyclic_random_id crand_id;      

      for (i=0; i<num_transactions; ++i) begin
	 crand_id = new();	   
	 axi_txn  = new();
	 
	 crand_id.randomize();	   
	 axi_txn.randomize() with { axi_txn.rw == WRITE; };
	 
	 if (master_id == 1)
	   axi_txn.id = crand_id.val_0_7;
	 else
	   axi_txn.id = crand_id.val_8_F;
	 
 	 start_item(axi_txn);
	 finish_item(axi_txn);	   
      end      
   endtask // body
   
endclass // axi_sequence

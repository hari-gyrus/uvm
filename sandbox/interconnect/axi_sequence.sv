// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_sequence extends uvm_sequence #(axi_transaction);
   `uvm_object_utils(axi_sequence)
   
   master_id = 0;   
   num_transactions = 5;
   
   function new (name);
      super.new(name);      
   endfunction // new

   task body;
      int i;
      cyclic_random_id cid;      
      axi_transaction axi_tx;

      for (i=0; i<num_transactions; ++i)
	begin
	   axi_tx = axi_transactions::typeid::create(axi_tx, this);
	   axi_tx.randomize() with rw = WRITE;
	   cid.randomize();	   

	   if (master_id == 1)
	     axi_tx.id = cid.val_7_0;
	   else
	     axi_tx.id = cid.val_F_8;
	   
	   start_item(axi_tx);
	   finish_item(axi_tx);	   
	end
      
   endtask // body
   
endclass // axi_sequence

// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class axi_master_simple_sequence extends uvm_sequence #(axi_transaction);
   `uvm_object_utils(axi_master_simple_sequence)

   int master_id;
   int num_transactions = 0;
   
   function new (string name = "");
      super.new(name);
   endfunction // new
   
   task body ();
      string axi_txn_name;      
      axi_transaction axi_txn;
      cyclic_random_id axi_mid0, axi_mid1;   

      axi_txn = new();
      
      axi_mid0 = new();
      axi_mid1 = new();

      for (int i = 0; i < num_transactions; ++i) begin
	 axi_txn_name = $psprintf("axi_txn_%d", i);	 
	 axi_txn = axi_transaction::type_id::create(axi_txn_name);
	 start_item(axi_txn);	 
	 axi_txn.randomize() with {axi_txn.rw == WRITE;};

	 if (master_id == 0) begin
	    assert(axi_mid0.randomize());
	    axi_txn.id = axi_mid0.val_0_7;	    
	 end
	 else if (master_id == 1) begin
	    assert(axi_mid1.randomize());
	    axi_txn.id = axi_mid1.val_8_F;	    
	 end
	 
	 finish_item(axi_txn);	 	 
	 `uvm_info("body", $psprintf("Sending AXI transaction: %s", axi_txn.convert2string()), UVM_MEDIUM)
      end
      
   endtask // body
   
endclass // axi_master_simple_sequence


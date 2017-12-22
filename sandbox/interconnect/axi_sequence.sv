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
	 axi_txn.randomize() with { axi_txn.rw == WRITE; axi_txn.length == 1; };
	 
	 if (master_id == 1)
	   axi_txn.id = crand_id.val_0_7;
	 else
	   axi_txn.id = crand_id.val_8_F;
	 
 	 start_item(axi_txn);

	 // NOTE: Start_item statement above is blocking until the transaction gets pulled out from the agent's sequencer/driver.
	 //       The below info statement gets printed only after the trasaction is pulled out 
	 //       1. Time 0:   axi_master_driver run_phase start
	 //       2. Time 100: axi_master_driver.run_phase wait's for reset to be deasserted
	 //                    axi_master_driver.run_phase kick's starts manage_sequencer_txn
	 //       3. Time 105: axi_master_driver.manage_sequencer_txn wait's for posedge of clk
	 //                    axi_master_driver.manage_sequencer_txn pulls out next transaction

	 `uvm_info("AXI-SEQUENCE", $psprintf("Master %d sending Transaction(%d): %s", master_id, i, axi_txn.convert2string), UVM_MEDIUM) 

	 finish_item(axi_txn);	   
      end      
   endtask // body
   
endclass // axi_sequence

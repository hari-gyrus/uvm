// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

// cyclic_random_id
//   1. random data items
//   2. random constraints
//   3. function new

class cyclic_random_id extends uvm_sequence_item;
   `uvm_object_utils(cyclic_random_id)

   //   1. random data items
   rand bit [3:0] val_0_7;
   rand bit [3:0] val_8_F;   

   //   2. random constraints
   constraint master_id {
      val_0_7 inside { [0:7] };
      val_8_F inside { [8:15] };
   }
      
   function new (string name = "cyclic_random_id");      
      super.new(name);      
   endfunction // new
   
endclass // cyclic_random_id


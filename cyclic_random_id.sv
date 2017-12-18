// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class cyclic_random_id extends uvm_sequence_item;
   `uvm_object_utils(cyclic_random_id)
   
   rand bit [3:0] val_7_0;
   rand bit [3:0] val_8_F;

   constraint master_id {
      val_7_0 inside { [0:7] };
      val_F_8 inside { [8:15] };   
   }     
       
   function new (string name);
      super.new(name);      
   endfunction // new
   
endclass // cyclic_random_id


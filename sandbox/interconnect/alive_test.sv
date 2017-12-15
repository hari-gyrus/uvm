// ********************************************************************************
// Copyright (c) 2017-2018: Gyrus, Inc
// 
// This file can not be copied and/or distributed without the express permission 
// of Gyrus, Inc. Subject to terms of license agreement - Check "LICENSE" which 
// comes with this distribution for more information.
// ********************************************************************************

class alive_test extends uvm_test;
   `uvm_component_utils(alive_test)

   function new (string name, uvm_component parent);
      super.new(name, parent);      
   endfunction // new
   
endclass // alive_test

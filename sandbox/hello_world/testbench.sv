
`include "uvm_macros.svh"

`include "my_intf.svh"
`include "my_pkg.svh"

module testbench;
   import uvm_pkg::*;   
   import my_pkg::*;

   dut_if dut_if_tb();

   design design (.d_if(dut_if_tb));
   
   initial
     begin
	run_test("hello_world");	
     end
   
endmodule // testbench


`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_test_pkg::*;
module axi_tb_top;

initial begin
	run_test("base_test");
end
endmodule

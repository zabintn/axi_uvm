`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_test_pkg::*;
module axi_tb_top;

axi_if axi_vif(clk);

initial begin
	uvm_config_db#(virtual axi_if) :: set(uvm_root :: get(), "uvm_test_top.env_o.agt.*", "vif", axi_vif);
end

initial begin
	run_test("base_test");
end
endmodule

`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_test_pkg::*;
module axi_tb_top;

bit clk;

int clk_frequency_mhz;
int clk_period_ns;
initial begin
        if($value$plusargs("CLK_FREQUENCY=%d", clk_frequency_mhz)) begin
                $display("Clock frequency overwritten to %0d MHz", clk_frequency_mhz);
        end
        
        clk_period_ns=1000/clk_frequency_mhz;
end


always #(clk_period_ns/2) clk = ~clk;

axi_if axi_vif(clk);

initial begin
	uvm_config_db#(virtual axi_if) :: set(uvm_root :: get(), "uvm_test_top.env_o.agt.*", "vif", axi_vif);
end

initial begin
	run_test("base_test");
end
endmodule

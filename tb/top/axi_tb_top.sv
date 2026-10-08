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

axi_if axi_vif [MASTER_NUM] (clk);
for(genvar i=0; i<MASTER_NUM; i++) begin
	initial begin
		axi_vif[i].awready = 1;
 		axi_vif[i].wready  = 1;
  		axi_vif[i].arready = 1;
  		axi_vif[i].bvalid  = 0;
  		axi_vif[i].rvalid  = 0;
	end

	always @(posedge clk) begin
 		 if (axi_vif[i].bvalid && axi_vif[i].bready) axi_vif[i].bvalid <= 0;
  		if (axi_vif[i].wvalid && axi_vif[i].wlast)  axi_vif[i].bvalid <= 1;
	end

	always @(posedge clk) begin
 		 if (axi_vif[i].rvalid && axi_vif[i].rready) axi_vif[i].rvalid <= 0;
  		if (axi_vif[i].arvalid) begin
    		axi_vif[i].rvalid <= 1;
    		axi_vif[i].rlast  <= 1;
  		end
	end
	
	
	initial begin
		uvm_config_db#(virtual axi_if) :: set(uvm_root :: get(), $sformatf("uvm_test_top.env_o.agt[%0d].*", i), "vif", axi_vif[i]);
	end
end

initial begin
	run_test("base_test");
end
endmodule

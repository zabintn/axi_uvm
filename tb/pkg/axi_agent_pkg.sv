

package axi_agent_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import axi_param_pkg::*;
	`include "../seq_lib/axi_sequence_item.sv"
	`include "../seq_lib/axi_base_sequence.sv"
	`include "../seq_lib/axi_sequencer.sv"
	`include "../agent/axi_driver.sv"
	`include "../agent/axi_monitor.sv"
	`include "../agent/axi_agent.sv"
endpackage

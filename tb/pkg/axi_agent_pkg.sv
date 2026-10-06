package axi_agent_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import axi_param_pkg::*;
	import axi_seq_lib_pkg::*;
	`include "../agent/axi_driver.sv"
	`include "../agent/axi_monitor.sv"
	`include "../agent/axi_agent.sv"
endpackage

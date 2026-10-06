package axi_seq_lib_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import axi_param_pkg::*;
	`include "../seq_lib/axi_sequence_item.sv"
	`include "../seq_lib/axi_base_sequence.sv"
	`include "../seq_lib/axi_read_sequence.sv"	
	`include "../seq_lib/axi_write_sequence.sv"
	`include "../seq_lib/axi_reset_sequence.sv"
	`include "../seq_lib/axi_test_sequence.sv"
	`include "../seq_lib/axi_sequencer.sv"
endpackage

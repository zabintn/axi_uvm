class axi_base_sequence extends uvm_sequence#(axi_seq_item);

	`uvm_object_utils(axi_base_sequence)

	function new(string name="axi_base_sequence");
		super.new(name);
	endfunction

	task body();
		`uvm_info(get_full_name(), "INSIDE BASE SEQUENCE BODY TASK", UVM_MEDIUM);
	endtask

endclass

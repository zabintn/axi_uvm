class axi_driver extends uvm_driver#(axi_seq_item);
	`uvm_component_utils(axi_driver);

	function new(string name="axi_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE DRIVER BUILD PHASE", UVM_MEDIUM);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);	
		`uvm_info(get_full_name(), "INSIDE DRIVER CONNECT PHASE", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE DRIVER RUN PHASE", UVM_MEDIUM);
	endtask

endclass
	

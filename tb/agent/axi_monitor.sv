class axi_monitor extends uvm_monitor;
	`uvm_component_utils(axi_monitor);

	function new(string name="axi_monitor", uvm_component parent=null);
		super.new(name, parent); //have to create the item collect port here
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase); //have to get the interface here
		`uvm_info(get_full_name(), "INSIDE MONITOR BUILD PHASE", UVM_MEDIUM);
	endfunction

	function void connect_phase(uvm_phase phase);
		`uvm_info(get_full_name(),"INSIDE MONITOR CONNNECT PHASE", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE MONITOR RUN PHASE", UVM_MEDIUM);
	endtask
endclass

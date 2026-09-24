class axi_scoreboard extends uvm_scoreboard;

	//analysis port declarations
	//
	`uvm_component_utils(axi_scoreboard)

	function new(string name="axi_scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD BUILD PHASE", UVM_MEDIUM);
	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD CONNECT PHASE", UVM_MEDIUM);
	endfunction

	function void write(axi_seq_item req);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD WRITE FUNCTION", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD RUN PHASE", UVM_MEDIUM);
	endtask

endclass

class axi_base_test extends uvm_test;
	axi_env env_o;
	axi_base_sequence bseq;
	`uvm_component_utils(axi_base_test)

	function new(string name="axi_base_test", uvm_component parent= null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE BASE TEST BUILD PHASE", UVM_MEDIUM);
		super.build_phase(phase);
		env_o=axi_env::type_id::create("env_o", this);
		`uvm_info(get_full_name(), "ENV CREATED", UVM_HIGH);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), "INSIDE BASE TEST CONNECT PHASE", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE BASE TEST RUN PHASE", UVM_MEDIUM);
		bseq=axi_base_sequence::type_id::create("bseq", this);
	endtask
endclass

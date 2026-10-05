class axi_env extends uvm_env;
	axi_scoreboard sb;
	axi_agent agt;
	axi_reference_model rf;

	`uvm_component_utils(axi_env);

	function new(string name= "axi_env", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE ENVIRONMENT BUILD PHASE", UVM_MEDIUM);
		agt=axi_agent::type_id::create("agt", this);
		sb=axi_scoreboard::type_id::create("sb", this);
		rf=axi_reference_model::type_id::create("rf", this);
		`uvm_info(get_full_name(), "CREATED AGENT AND SCOREBOARD", UVM_MEDIUM);
	endfunction

	function void connect_phase(uvm_phase phase); //monitor scoreboard analysis port connection here
		super.connect_phase(phase);
		`uvm_info(get_full_name(), "INSIDE ENVIRONMENT CONNECT PHASE", UVM_MEDIUM);
		agt.mon.item_collect_port.connect(sb.item_collect_export);
		agt.mon.item_collect_port.connect(rf.collect_item_export);
		rf.refmodel_collect.connect(sb.refmodel_export);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE ENVRIONMENT RUN PHASE", UVM_MEDIUM);
	endtask
endclass

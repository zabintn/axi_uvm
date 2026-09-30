class axi_monitor extends uvm_monitor;
	uvm_analysis_port #(axi_seq_item) item_collect_port;


	`uvm_component_utils(axi_monitor);
	
	virtual axi_if axi_vif;
	function new(string name="axi_monitor", uvm_component parent=null);
		super.new(name, parent); //have to create the item collect port here
		item_collect_port=new("item_collect_port", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase); //have to get the interface here
		`uvm_info(get_full_name(), "INSIDE MONITOR BUILD PHASE", UVM_MEDIUM);
		if (!uvm_config_db#(virtual axi_if):: get(this, "", "vif", axi_vif))
			`uvm_fatal(get_type_name(), "Not Set at Top Level");
	endfunction

	function void connect_phase(uvm_phase phase);
		`uvm_info(get_full_name(),"INSIDE MONITOR CONNNECT PHASE", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE MONITOR RUN PHASE", UVM_MEDIUM);
	endtask
endclass

class axi_sequencer extends uvm_sequencer#(axi_seq_item);
	axi_seq_item req;
	virtual axi_if axi_vif;
	`uvm_component_utils(axi_sequencer)

	function new(string name= "axi_sequencer", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE SEQUENCER BUILD PHASE", UVM_MEDIUM);	
	endfunction

endclass

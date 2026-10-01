class axi_dummy_test extends axi_base_test;
	axi_test_sequence tseq;
	`uvm_component_utils(axi_dummy_test)

	function new(string name="axi_dummy_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_full_name(), "BEFORE RUN PHASE OF DUMMY TEST", UVM_MEDIUM);
		phase.raise_objection(this);
		tseq=axi_test_sequence::type_id::create("tseq");
		tseq.awaddr= 32'h0000_00012;
		tseq.start(env_o.agt.seqr);
		
		phase.drop_objection(this);
		`uvm_info(get_full_name(), "AFTER RUN PHASE OF DUMMY TEST", UVM_LOW);
	endtask
endclass

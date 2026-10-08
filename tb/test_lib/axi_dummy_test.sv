class axi_dummy_test extends axi_base_test;
	axi_concurrent_sequence tseq;
	`uvm_component_utils(axi_dummy_test)

	function new(string name="axi_dummy_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);

  		for (int i = 0; i < 5; i++) begin
    			tseq = axi_concurrent_sequence::type_id::create("tseq");
    			tseq.awaddr = 32'h12; tseq.awlen = 8'd3; tseq.araddr = 32'h12; tseq.aresetn = 1;
    			tseq.start(env_o.agt[0].seqr);
  		end

  		repeat (20) @(posedge env_o.agt[0].drv.axi_vif.clk);

  		tseq = axi_concurrent_sequence::type_id::create("rst_seq");
  		tseq.aresetn = 0; tseq.awaddr = 32'h12; tseq.awlen = 8'd10; tseq.araddr = 32'h12;
  		tseq.start(env_o.agt[0].seqr);

  		wait (env_o.agt[0].drv.outstanding_wr == 0 && env_o.agt[0].drv.outstanding_rd == 0);
  		repeat (5) @(posedge env_o.agt[0].drv.axi_vif.clk);   //delay

 		 `uvm_info(get_full_name(), "AFTER RUN PHASE OF DUMMY TEST", UVM_LOW);
  		phase.drop_objection(this);
	endtask
endclass

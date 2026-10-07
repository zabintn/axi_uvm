class axi_wrap_burst_read_test extends axi_base_test;
	axi_read_sequence rseq;
	`uvm_component_utils(axi_wrap_burst_read_test)

	function new(string name="axi_wrap_burst_read_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);

    		rseq = axi_read_sequence::type_id::create("rseq");
    		rseq.araddr = 32'h00; 
		rseq.arlen = 8'd2;
		rseq.arsize = 3'd3;
		rseq.arburst= 2'b10;
    		rseq.start(env_o.agt.seqr);

  		repeat (20) @(posedge env_o.agt.drv.axi_vif.clk);

 		 `uvm_info(get_full_name(), "AFTER RUN PHASE OF WRITE TEST", UVM_LOW);
  		phase.drop_objection(this);
	endtask
endclass

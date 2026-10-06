class axi_reset_test extends axi_base_test;
	axi_read_sequence rseq;
	axi_reset_sequence rstseq;
	axi_write_sequence wseq;
	
	`uvm_component_utils(axi_reset_test)

	function new(string name="axi_reset_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);

  		for (int i = 0; i < 5; i++) begin
    			rseq = axi_read_sequence::type_id::create("rseq");
    			rseq.aresetn = 1'b1; 
			rseq.araddr = '0;
			rseq.arlen = 8'd3; 
			rseq.arburst = 2'b01; 
    			rseq.start(env_o.agt.seqr);
  		end

  		repeat (20) @(posedge env_o.agt.drv.axi_vif.clk);

  		rstseq = axi_reset_sequence::type_id::create("rst_seq");
		rstseq.start(env_o.agt.seqr);

  		wait (env_o.agt.drv.outstanding_wr == 0 && env_o.agt.drv.outstanding_rd == 0);
  		repeat (5) @(posedge env_o.agt.drv.axi_vif.clk);   //delay

 		 `uvm_info(get_full_name(), "AFTER RUN PHASE OF RESET TEST", UVM_LOW);
  		phase.drop_objection(this);
	endtask
endclass

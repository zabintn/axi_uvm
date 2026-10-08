class axi_incr_burst_write_test extends axi_base_test;
	axi_write_sequence wseq;
	`uvm_component_utils(axi_incr_burst_write_test)

	function new(string name="axi_incr_burst_write_test", uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);

    		wseq = axi_write_sequence::type_id::create("wseq");
    		wseq.awaddr = 32'h00; 
		wseq.awlen = 8'd0;
		wseq.awsize = 3'd3;
		wseq.awburst= 2'b01;
    		wseq.start(env_o.agt[0].seqr);

  		repeat (20) @(posedge env_o.agt[0].drv.axi_vif.clk);

 		 `uvm_info(get_full_name(), "AFTER RUN PHASE OF WRITE TEST", UVM_LOW);
  		phase.drop_objection(this);
	endtask
endclass

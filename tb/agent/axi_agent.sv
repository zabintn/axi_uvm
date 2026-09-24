class axi_agent extends uvm_agent;
	axi_driver drv;
	axi_monitor mon;
	axi_sequencer seqr;
	`uvm_component_utils(axi_agent);


	function new(string name="axi_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE AGENT BUILD PHASE", UVM_MEDIUM);
		 if (get_is_active() == UVM_ACTIVE) begin
			 drv=axi_driver::type_id::create("drv", this);
			 seqr=axi_sequencer::type_id::create("seqr", this);
		 end

		 mon=axi_monitor::type_id::create("mon", this);
	 endfunction

	 function void connect_phase(uvm_phase phase);
		 super.connect_phase(phase);

		 //add seqr driver here

		 `uvm_info(get_full_name(), "INSIDE AGENT CONNECT PHASE", UVM_MEDIUM);
	 endfunction

	 task run_phase(uvm_phase phase);
		 `uvm_info(get_full_name(), "INSIDE AGENT RUN PHASE", UVM_MEDIUM);
	 endtask

 endclass


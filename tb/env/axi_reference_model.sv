class axi_reference_model extends uvm_component;
	uvm_analysis_imp #(axi_seq_item, axi_reference_model) collect_item_export;
	uvm_analysis_port #(axi_seq_item) refmodel_collect;
	axi_seq_item item_q[$];
	//declare a queue and get item
	
	`uvm_component_utils(axi_reference_model)

	function new(string name="axi_reference_model", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE REFERENCE MODEL BUILD PHASE", UVM_MEDIUM);
		collect_item_export=new("collect_item_export", this);
		refmodel_collect=new("refmodel_collect", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), "INSIDE REFERENCE MODEL CONNECT PHASE", UVM_MEDIUM);
	endfunction
	
	function void write(axi_seq_item req);
		`uvm_info(get_full_name(), "INSIDE WRITE FUNCTION OF REFMODDEL", UVM_MEDIUM);
		item_q.push_back(req);
	endfunction

	task run_phase(uvm_phase phase);
		axi_seq_item ref_item;
		axi_seq_item ref_q;
		`uvm_info(get_full_name(), "INSIDE REFERENCE MODEL RUN PHASE", UVM_MEDIUM);
		
		forever begin
			wait(item_q.size()>0);
			
			if(item_q.size()>0) begin
				ref_item=item_q.pop_front();
				
				if(ref_item.axi_op==0)
					write_addr_decode(ref_item);
				else 
					read_addr_decode(ref_item);
			end
		end
	endtask
	
	task write_addr_decode(axi_seq_item ref_item);
		axi_seq_item exp_item;
		$cast(exp_item, ref_item.clone());	
		if (ref_item.awaddr>ADDRESS_CEIL) begin
			exp_item.bresp=2'b11;
		end
		else begin		
			exp_item.bresp=2'b00;
		end
		refmodel_collect.write(exp_item);
	endtask


	task read_addr_decode(axi_seq_item ref_item);
		axi_seq_item exp_item;
		$cast(exp_item, ref_item.clone());
		for(int i=0; i< (ref_item.arlen + 1); i++) begin 	
			if (ref_item.araddr>ADDRESS_CEIL) begin
				exp_item.rresp[i]=2'b11;
			end
			else begin		
			exp_item.rresp[i]=2'b00;
			end
		end
		refmodel_collect.write(exp_item);
	endtask

endclass

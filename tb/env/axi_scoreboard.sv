`uvm_analysis_imp_decl(_act)
`uvm_analysis_imp_decl(_exp)

class axi_scoreboard extends uvm_scoreboard;

	//analysis port declarations	
	axi_seq_item act_q[$];
	axi_seq_item exp_q[bit [ID_WIDTH-1:0]][$];


	uvm_analysis_imp_act #(axi_seq_item, axi_scoreboard) item_collect_export;
	uvm_analysis_imp_exp #(axi_seq_item, axi_scoreboard) refmodel_export;
	`uvm_component_utils(axi_scoreboard)	
	function new(string name="axi_scoreboard", uvm_component parent=null);
		super.new(name, parent);
		item_collect_export= new("item_collect_export", this);
		refmodel_export=new("refmodel_export", this);

	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD BUILD PHASE", UVM_MEDIUM);
	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD CONNECT PHASE", UVM_MEDIUM);
	endfunction

	function void write_act(axi_seq_item req);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD WRITE FUNCTION", UVM_MEDIUM);
		act_q.push_back(req);
		`uvm_info(get_full_name(), $sformatf("awid=%0h awaddr=%0h", req.awid, req.awaddr), UVM_MEDIUM)
	endfunction

	function void write_exp(axi_seq_item req);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD WRITE FUNCTION", UVM_MEDIUM);
		exp_q[req.awid].push_back(req);
		`uvm_info(get_full_name(), $sformatf("awid=%0h awaddr=%0h", req.awid, req.awaddr), UVM_MEDIUM);
	endfunction
	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE SCOREBOARD RUN PHASE", UVM_MEDIUM);
		forever begin
			axi_seq_item sb_item;	
			wait(act_q.size()>0);
			if(act_q.size()>0) begin
				sb_item=act_q.pop_front();
				if(sb_item.axi_op==0)
					write_check(sb_item);
				else
					read_check(sb_item);
			end	
		end
	endtask
	
	task write_check(axi_seq_item sb_item);
		axi_seq_item exp;
		int id;
		id=sb_item.awid;
		wait (exp_q.exists(id) && exp_q[id].size() > 0);
		exp=exp_q[sb_item.awid].pop_front();	
		if(sb_item.bresp==exp.bresp) 
			`uvm_info(get_full_name(), $sformatf("MATCH id=%0h", sb_item.awid), UVM_MEDIUM)
		else
			`uvm_error(get_full_name(), $sformatf("MISMATCH id=%0h exp=%0b act=%0b", sb_item.awid, exp.bresp, sb_item.bresp))
	endtask

	task read_check(axi_seq_item sb_item);
		axi_seq_item exp;
		int id;
		id=sb_item.arid;
		wait (exp_q.exists(id) && exp_q[id].size() > 0);
		exp=exp_q[sb_item.awid].pop_front();	
		for(int i=0; i<(sb_item.arlen + 1); i++) begin
			if(sb_item.rresp[i]==exp.rresp[i]) 
			`uvm_info(get_full_name(), $sformatf("MATCH id=%0h", sb_item.arid), UVM_MEDIUM)
		else
			`uvm_error(get_full_name(), $sformatf("MISMATCH id=%0h exp=%0b act=%0b", sb_item.arid, exp.rresp[i], sb_item.rresp[i]));
	end
	endtask
endclass

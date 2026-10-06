`uvm_analysis_imp_decl(_act)
`uvm_analysis_imp_decl(_exp)

class axi_scoreboard extends uvm_scoreboard;

	//analysis port declarations	
	axi_seq_item act_q[$];
	axi_seq_item exp_q[bit [ID_WIDTH-1:0]][$];
        bit [DATA_WIDTH-1:0] expected_mem [bit[ADDR_WIDTH-1:0]];
	int fail_count=0;
	int pass=0;
	int fail=0;


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
				if(sb_item.axi_op==0) begin
					for (int i=0; i<(sb_item.awlen+1); i++) begin
						case(sb_item.awburst)
							2'b00: begin
								expected_mem[sb_item.awaddr]=sb_item.wdata[i];
								`uvm_info(get_full_name(), $sformatf("MEMORY WRITE=%0h", expected_mem[sb_item.awaddr]), UVM_LOW)
							end
							2'b01: begin
								expected_mem[sb_item.awaddr+i*(1<<sb_item.awsize)]=sb_item.wdata[i];
								`uvm_info(get_full_name(), $sformatf("MEMORY WRITE=%0h", expected_mem[sb_item.awaddr+i*(1<<sb_item.awsize)]), UVM_LOW)
								end
							2'b10: begin
								int num_bytes   = 1 << sb_item.awsize;
								int total_bytes = num_bytes * (sb_item.awlen + 1);
								int wrap_lo = (sb_item.awaddr / total_bytes) * total_bytes;
								int addr    = sb_item.awaddr + i * num_bytes;
								if (addr >= wrap_lo + total_bytes)
               								addr -= total_bytes;

        							expected_mem[addr] = sb_item.wdata[i];
								`uvm_info(get_full_name(), $sformatf("MEMORY WRITE=%0h", expected_mem[addr]), UVM_LOW)
								end
						endcase	
					end
						write_check(sb_item);
				end
				else
					read_check(sb_item);
			end
		
		if(fail_count==0)
			pass++;
		else	
			fail++;
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
		else begin
			`uvm_error(get_full_name(), $sformatf("MISMATCH id=%0h exp=%0b act=%0b", sb_item.awid, exp.bresp, sb_item.bresp))
			fail_count++;
		end
		endtask

	task read_check(axi_seq_item sb_item);
		int unsigned num_bytes = 1 << sb_item.arsize;
		longint unsigned addr;
		bit [DATA_WIDTH-1:0] exp_data;
		axi_seq_item exp;
		int id;
		id=sb_item.arid;
		wait (exp_q.exists(id) && exp_q[id].size() > 0);
		exp=exp_q[sb_item.arid].pop_front();


		for(int i=0; i<(sb_item.arlen + 1); i++) begin
			`uvm_info(get_full_name(), $sformatf("rdata=%0h", sb_item.rdata[i]), UVM_MEDIUM)
			if(sb_item.rresp[i]==exp.rresp[i]) 
				`uvm_info(get_full_name(), $sformatf("MATCH id=%0h", sb_item.arid), UVM_MEDIUM)
			else begin
				`uvm_error(get_full_name(), $sformatf("MISMATCH id=%0h exp=%0b act=%0b", sb_item.arid, exp.rresp[i], sb_item.rresp[i]));	
				fail_count++;
			end
		
			case (sb_item.arburst)
        			2'b00: addr = sb_item.araddr;
        			2'b01: addr = sb_item.araddr + i*num_bytes;
        			2'b10: begin
				
					int unsigned total_bytes = num_bytes * (sb_item.arlen + 1);
                			longint unsigned wrap_lo = (sb_item.araddr / total_bytes) * total_bytes;
                			addr = sb_item.araddr + i*num_bytes;
                			if (addr >= wrap_lo + total_bytes)
                        		addr -= total_bytes;
        				end
        				default: addr = sb_item.araddr;
			endcase

			exp_data = expected_mem.exists(addr) ? expected_mem[addr] : '0;
			
			if (sb_item.rdata[i] == exp_data)
				`uvm_info(get_full_name(), $sformatf("BEAT %0d MATCH", i), UVM_MEDIUM)
			else begin
				`uvm_error(get_full_name(), $sformatf("BEAT %0d MISMATCH addr=%0h exp=%0h act=%0h", i, addr, exp_data, sb_item.rdata[i]))
				fail_count++;
			end

		end
	endtask

	function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        if (act_q.size() != 0)
                `uvm_error(get_full_name(), $sformatf("%0d items left unchecked in act_q", act_q.size()))
        if (fail_count != 0)
                `uvm_error(get_full_name(), $sformatf("%0d beats mismatched", fail_count))
	endfunction
	
	function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_full_name(), $sformatf("PASS=%0d, FAIL=%0d", pass, fail), UVM_LOW)
	endfunction
endclass

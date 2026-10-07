class axi_functional_coverage extends uvm_subscriber #(axi_seq_item);
	`uvm_component_utils(axi_functional_coverage)

	axi_seq_item req;
	bit [1:0] rresp_beat;
	covergroup axi_cg;
		cp_op: coverpoint req.axi_op {
			bins write = {0};
			bins read = {1};
			}
		cp_wr_burst: coverpoint req.awburst {
			bins fixed = {2'b00};
			bins incr = {2'b01};
			bins wrap = {2'b10};
			}
		cp_rd_burst: coverpoint req.arburst {
			bins fixed = {2'b00};
			bins incr = {2'b01};
			bins wrap = {2'b10};
			}
		cp_wr_err: coverpoint req.bresp {
			bins okay = {2'b00};
			bins exokay = {2'b01};
			bins decerr = {2'b11};
			bins slverr = {2'b10};
			}
		cp_rd_err: coverpoint rresp_beat {
			bins okay = {2'b00};
			bins exokay = {2'b01};
			bins decerr = {2'b11};
			bins slverr = {2'b10};
			}

	endgroup


	function new(string name="axi_functional_coverage", uvm_component parent=null);
		super.new(name,parent);
		axi_cg=new();
	endfunction

	function void write(axi_seq_item t);
		req=t;
		foreach (req.rresp[i]) begin
			rresp_beat=req.rresp[i];
		end
		axi_cg.sample();
	endfunction

	function void report_phase(uvm_phase phase);
		`uvm_info(get_full_name(), $sformatf("FUNCTIONAL COVERAGE =%.2f", axi_cg.get_coverage()), UVM_LOW)
	endfunction
endclass

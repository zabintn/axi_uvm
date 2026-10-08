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
			illegal_bins illegal= {2'b11};
			}
		cp_rd_burst: coverpoint req.arburst {
			bins fixed = {2'b00};
			bins incr = {2'b01};
			bins wrap = {2'b10};
			illegal_bins illegal= {2'b11};
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
		cp_awvalid: coverpoint req.awvalid {
			bins high = {1};
			bins low = {0};
			}
		cp_awready: coverpoint req.awready {
			bins high = {1};
			bins low = {0};
			}
		cx_aw_handshake: cross cp_awready, cp_awvalid {
			bins handshake = binsof(cp_awready.high) && binsof(cp_awvalid.low);
			}
		cp_wvalid: coverpoint req.wvalid {
			bins high = {1};
			bins low = {0};
			}
		cp_wready: coverpoint req.wready {
			bins high = {1};
			bins low = {0};
			}
		cx_w_handshake: cross cp_wready, cp_wvalid {
			bins handshake = binsof(cp_wready.high) && binsof(cp_wvalid.high);
			}
		cp_bvalid: coverpoint req.bvalid {
			bins high = {1};
			bins low = {0};
			}
		cp_bready: coverpoint req.bready {
			bins high = {1};
			bins low = {0};
			}
		cx_b_handshake: cross cp_bready, cp_bvalid {
			bins handshake = binsof(cp_bready.high) && binsof(cp_bvalid.high);
			}
		cp_rvalid: coverpoint req.rvalid {
			bins high = {1};
			bins low = {0};
			}
		cp_rready: coverpoint req.rready {
			bins high = {1};
			bins low = {0};
			}
		cx_r_handshake: cross cp_rready, cp_rvalid {
			bins handshake = binsof(cp_rready.high) && binsof(cp_rvalid.high);
			}
		cp_arvalid: coverpoint req.arvalid {
			bins high = {1};
			bins low = {0};
			}
		cp_arready: coverpoint req.arready {
			bins high = {1};
			bins low = {0};
			}
		cx_ar_handshake: cross cp_arready, cp_arvalid {
			bins handshake = binsof(cp_arready.high) && binsof(cp_arvalid.high);
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

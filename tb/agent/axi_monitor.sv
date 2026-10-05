class axi_monitor extends uvm_monitor;
	uvm_analysis_port #(axi_seq_item) item_collect_port;
	axi_seq_item mon_item;

	`uvm_component_utils(axi_monitor);
	
	virtual axi_if axi_vif;
	function new(string name="axi_monitor", uvm_component parent=null);
		super.new(name, parent); //have to create the item collect port here
		item_collect_port=new("item_collect_port", this);
		mon_item=new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase); //have to get the interface here
		`uvm_info(get_full_name(), "INSIDE MONITOR BUILD PHASE", UVM_MEDIUM);
		if (!uvm_config_db#(virtual axi_if):: get(this, "", "vif", axi_vif))
			`uvm_fatal(get_type_name(), "Not Set at Top Level");
	endfunction

	function void connect_phase(uvm_phase phase);
		`uvm_info(get_full_name(),"INSIDE MONITOR CONNNECT PHASE", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info(get_full_name(), "INSIDE MONITOR RUN PHASE", UVM_MEDIUM);
		fork 
			capture_aw();
			capture_w();
			capture_b();
			capture_ar();
			capture_r();
		join_none
	endtask

	task capture_aw();
		forever begin
		do begin 
			@(posedge axi_vif.clk);
		end while ((axi_vif.awvalid && axi_vif.awready) !== 1);
			`uvm_info (get_full_name(), "AW VALID READY HANDSHAKE", UVM_LOW);
			mon_item.awaddr<=axi_vif.awaddr;
			mon_item.awid<=axi_vif.awid;
			mon_item.awlen<=axi_vif.awlen;
			mon_item.awsize<=axi_vif.awsize;
			mon_item.awburst<=axi_vif.awburst;
	
		item_collect_port.write(mon_item);
		end
	endtask
	task capture_w();
		bit wlast_seen;
		int beat_cnt;
		bit [DATA_WIDTH-1:0] wdata_q[$];
		bit [(DATA_WIDTH/8)-1:0] wstrb_q[$];
	forever begin
		wlast_seen=0;
		beat_cnt=0;

		wdata_q.delete();
		wstrb_q.delete();
		while(!wlast_seen) begin
			do begin 
				@(posedge axi_vif.clk);
			end while ((axi_vif.wvalid && axi_vif.wready) !== 1);
			`uvm_info (get_full_name(), $sformatf("W VALID READY HANDSHAKE BEAT=%0d", beat_cnt), UVM_LOW);
			wdata_q.push_back(axi_vif.wdata);
			wstrb_q.push_back(axi_vif.wstrb);
			wlast_seen=axi_vif.wlast;
			beat_cnt++;
		end
		mon_item.wdata=wdata_q;
		mon_item.wstrb=wstrb_q;	
		item_collect_port.write(mon_item);
		`uvm_info(get_full_name(), $sformatf("MONITOR WDATA=%0p", mon_item.wdata), UVM_LOW);
	end	
	endtask
	task capture_ar();
		forever begin
		do begin 
			@(posedge axi_vif.clk);
		end while ((axi_vif.arvalid && axi_vif.arready) !== 1);
			`uvm_info (get_full_name(), "AR VALID READY HANDSHAKE", UVM_LOW);
			mon_item.araddr<=axi_vif.araddr;
			mon_item.arid<=axi_vif.arid;
			mon_item.arlen<=axi_vif.arlen;
			mon_item.arsize<=axi_vif.arsize;
			mon_item.arburst<=axi_vif.arburst;
			item_collect_port.write(mon_item);
		end
	endtask
	task capture_b();
		forever begin
			do begin
				@(posedge axi_vif.clk);
			end while ((axi_vif.bvalid && axi_vif.bready) !== 1);
			`uvm_info(get_full_name(), "B VALID READY HANDSHAKE", UVM_LOW);
			mon_item.bid<=axi_vif.bid;
			mon_item.bresp<=axi_vif.bresp;
			item_collect_port.write(mon_item);
		end
	endtask
	
	task capture_r();
		bit rlast_seen;
		int beat_cnt;
		bit [DATA_WIDTH-1:0] rdata_q[$];
		bit [1:0] rresp_q[$];
	forever begin
		rlast_seen=0;
		beat_cnt=0;

		rdata_q.delete();
		rresp_q.delete();
		while(!rlast_seen) begin
			do begin 
				@(posedge axi_vif.clk);
			end while ((axi_vif.rvalid && axi_vif.rready) !== 1);
			`uvm_info (get_full_name(), $sformatf("R VALID READY HANDSHAKE BEAT=%0d", beat_cnt), UVM_LOW);
			rdata_q.push_back(axi_vif.rdata);
			rresp_q.push_back(axi_vif.rlast);
			rlast_seen=axi_vif.rlast;
			beat_cnt++;
		end
		mon_item.rid=axi_vif.rid;
		mon_item.rdata=rdata_q;
		mon_item.rresp=rresp_q;
		item_collect_port.write(mon_item);
	end	

	endtask
endclass

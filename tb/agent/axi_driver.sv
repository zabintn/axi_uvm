class axi_driver extends uvm_driver#(axi_seq_item);
	virtual axi_if axi_vif;
	`uvm_component_utils(axi_driver)
	uvm_phase run_ph;
	axi_seq_item aw_q[$], w_q[$], ar_q[$];
	process chan_p;


	int outstanding_rd, outstanding_wr;
	function new(string name="axi_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(), "INSIDE DRIVER BUILD PHASE", UVM_MEDIUM);
		if (!uvm_config_db#(virtual axi_if) :: get(this, "", "vif", axi_vif))
		       `uvm_fatal(get_type_name(), "NOT SET AT TOP LEVEL");	       
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);	
		`uvm_info(get_full_name(), "INSIDE DRIVER CONNECT PHASE", UVM_MEDIUM);
	endfunction

	task run_phase(uvm_phase phase);
		run_ph = phase;
		`uvm_info(get_full_name(), "INSIDE DRIVER RUN PHASE", UVM_MEDIUM);
		assert_reset();
		start_channels();		
			forever begin
			axi_seq_item item;
			seq_item_port.get_next_item(req);
			$cast(item, req.clone()); //store a clone of req in item before pushing
			if(item.aresetn==0) begin
				mid_reset();
			end
			else begin
				if(item.axi_op==0) begin
					aw_q.push_front(item);
					w_q.push_front(item);
					outstanding_wr++;
				end
				else begin	
					ar_q.push_front(item);
					outstanding_rd++;
				end	
			end
			seq_item_port.item_done();
		end
	endtask

	task aw_channel;
		forever begin	
			int aw_got_ready=0;
			axi_seq_item req;
			wait (aw_q.size() > 0);
			req= aw_q.pop_back();
			`uvm_info(get_type_name(), "INITIATING AW CHANNEL", UVM_LOW);
			axi_vif.awaddr<=req.awaddr;
			axi_vif.awid<=req.awid;
			axi_vif.awlen<=req.awlen;
			axi_vif.awsize<=req.awsize;
			axi_vif.awburst<=req.awburst;
			axi_vif.awvalid<=1'b1;
			for (int i=0; i<100; i++) begin
				@(posedge axi_vif.clk);
				if(axi_vif.awready==1) begin
					aw_got_ready=1;
					break;
				end
			end
			if (!aw_got_ready)
				`uvm_fatal("TIMEOUT", "AWREADY NOT HIGH FOR 100 CYCLES");

			axi_vif.awvalid<=1'b0;
		end
	
	endtask

	task w_channel;
		forever begin
			axi_seq_item req;
			int num_beats;
			int w_got_ready=0;

			wait (w_q.size()>0);
			req= w_q.pop_back();	
			num_beats=req.awlen+1;
			`uvm_info(get_type_name(), "INITIATING W CHANNEL", UVM_LOW);
			
			for(int i=0; i<num_beats; i++) begin
				axi_vif.wdata <= req.wdata[i];
				axi_vif.wstrb <= req.wstrb[i];
				axi_vif.wlast <= (i== num_beats-1);
				axi_vif.wvalid<= 1'b1;
				for (int j=0; j<100; j++) begin
					@(posedge axi_vif.clk);
					if(axi_vif.wready==1) begin
						w_got_ready=1;
						break;
					end
				end
				if (!w_got_ready)
					`uvm_fatal("TIMEOUT", "WREADY NOT HIGH FOR 100 CYCLES");
				axi_vif.wvalid<=1'b0;
			end
		end
	endtask

	task ar_channel;
                forever begin
                        int ar_got_ready=0;
                        axi_seq_item req;
                        wait (ar_q.size() > 0);
                        req= ar_q.pop_back();
                        `uvm_info(get_type_name(), "INITIATING AR CHANNEL", UVM_LOW);
                        axi_vif.araddr<=req.araddr;
                        axi_vif.arid<=req.arid;
                        axi_vif.arlen<=req.arlen;
                        axi_vif.arsize<=req.arsize;
                        axi_vif.arburst<=req.arburst;
                        axi_vif.arvalid<=1'b1;
                        for (int i=0; i<100; i++) begin
                                @(posedge axi_vif.clk);
                                if(axi_vif.arready==1) begin
                                        ar_got_ready=1;
                                        break;
                                end
                        end
                        if (!ar_got_ready)
                                `uvm_fatal("TIMEOUT", "ARREADY NOT HIGH FOR 100 CYCLES");

                        axi_vif.arvalid<=1'b0;

                end

        endtask

	task b_channel;

	       	`uvm_info("B_CHAN", $sformatf("b_channel started @%0t", $time), UVM_LOW)
		axi_vif.bready <= 1'b1;	
		forever begin
			@(posedge axi_vif.clk);
			if (axi_vif.bvalid && axi_vif.bready) begin
				if (outstanding_wr > 0) begin
					outstanding_wr--;
				end

      			else
        			`uvm_error("B_CHAN", "B response with no outstanding write");
    			end
  		end
	endtask
	
	task r_channel;
	
	       	`uvm_info("R_CHAN", $sformatf("r_channel started @%0t", $time), UVM_LOW)
		axi_vif.rready <= 1'b1;	
		forever begin
			@(posedge axi_vif.clk);
			if (axi_vif.rvalid && axi_vif.rready && axi_vif.rlast) begin
				if (outstanding_rd>0) begin
					outstanding_rd--;
				end
				else
					`uvm_error("R_CHAN", "R response with no outstanding read");
			end
		end
	endtask
	
	task assert_reset;	
		`uvm_info(get_full_name(), "RESET ASSERTED", UVM_LOW);
		axi_vif.aresetn<=0;	
		axi_vif.awvalid<=0;
		axi_vif.arvalid<=0;
		axi_vif.wvalid<=0;
		@(posedge axi_vif.clk);
		axi_vif.aresetn<=1;
		`uvm_info(get_full_name(), "RESET DEASSERTED", UVM_LOW);
	endtask

	task start_channels();
		fork 
		begin
			chan_p=process::self();
			fork 
				aw_channel;
				w_channel;
				ar_channel;
				b_channel;
				r_channel;
			join_none
		end
		join_none
	endtask
	task mid_reset;
	wait (outstanding_wr == 0 && outstanding_rd == 0); //get rid of this and the clock line for a MID RESET TEST
  	@(posedge axi_vif.clk);	
		if(chan_p != null && chan_p.status() != process::FINISHED) begin
			chan_p.kill();
		end
		aw_q.delete();
		w_q.delete();
		ar_q.delete();
		outstanding_rd=0;
		outstanding_wr=0;
		assert_reset();
		start_channels();
	
	endtask


endclass
	

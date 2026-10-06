class axi_read_sequence extends axi_base_sequence;
        `uvm_object_utils(axi_read_sequence)

        rand bit [ADDR_WIDTH-1:0] araddr;
	rand bit [LEN_WIDTH-1:0] arlen;
	rand bit [BURST_TYPE-1:0] arburst;
	rand bit [SIZE_WIDTH-1:0] arsize;
	rand bit aresetn;
        function new(string name= "axi_read_sequence");
                super.new(name);
        endfunction

        task body(); 
		axi_seq_item wr, rd;
		super.body();
                rd=axi_seq_item::type_id::create("rd");
		start_item(rd);
		rd.randomize with {
			aresetn== 1;
                        axi_op == 1;
                        araddr == local::araddr;
			arlen == local::arlen;
			arburst == local::arburst;
			arsize == local::arsize;
			};
                finish_item(rd);
        //        rd.print();
        endtask
endclass 

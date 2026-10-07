class axi_concurrent_sequence extends axi_base_sequence;
        `uvm_object_utils(axi_concurrent_sequence)

        rand bit [ADDR_WIDTH-1:0] awaddr;
	rand bit [LEN_WIDTH-1:0] awlen;
        rand bit [ADDR_WIDTH-1:0] araddr;
	rand bit aresetn;
        function new(string name= "axi_concurrent_sequence");
                super.new(name);
        endfunction

        task body(); 
		axi_seq_item wr, rd;
		super.body();
                rd=axi_seq_item::type_id::create("rd");
                wr=axi_seq_item::type_id::create("wr");
		start_item(wr);
		wr.randomize with {
			aresetn== local::aresetn;
                        axi_op == 0;
                        awaddr == local::awaddr;
			awlen == local::awlen;
			};
                finish_item(wr);	
          //      wr.print();
		if(aresetn==0) return;
		start_item(rd);
		rd.randomize with {
			aresetn== local::aresetn;
                        axi_op == 1;
                        araddr == local::araddr;
			};
                finish_item(rd);
        //        rd.print();
        endtask
endclass 

class axi_write_sequence extends axi_base_sequence;
        `uvm_object_utils(axi_write_sequence)

        rand bit [ADDR_WIDTH-1:0] awaddr;
        rand bit [LEN_WIDTH-1:0] awlen;
        rand bit [SIZE_WIDTH-1:0] awsize;
        rand bit [BURST_TYPE-1:0] awburst;
        function new(string name= "axi_write_sequence");
                super.new(name);
        endfunction

        task body();
                super.body();
                req=axi_seq_item::type_id::create("req");
		start_item(req);
		req.randomize with {
			aresetn==1;
                        axi_op ==0;
                        awaddr == local::awaddr;
			awsize == local::awsize;
			awlen == local::awlen;
			awburst== local::awburst;
			};
                finish_item(req);
                req.print();
        endtask
endclass 

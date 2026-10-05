class axi_write_sequence extends axi_base_sequence;
        `uvm_object_utils(axi_test_sequence)

        rand bit [ADDR_WIDTH-1:0] awaddr;
        function new(string name= "axi_test_sequence");
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
			};
			end
                finish_item(req);
                req.print();
        endtask
endclass 

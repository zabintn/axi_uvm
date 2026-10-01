class axi_test_sequence extends axi_base_sequence;
        `uvm_object_utils(axi_test_sequence)

        rand bit [ADDR_WIDTH-1:0] awaddr;
        rand bit [ADDR_WIDTH-1:0] araddr;
        function new(string name= "axi_test_sequence");
                super.new(name);
        endfunction

        task body();
                super.body();
                req=axi_seq_item::type_id::create("req");
                start_item(req);
                req.randomize with {
                        aresetn==1;
                        axi_op ==1;
                        araddr == local::araddr;
			};
                finish_item(req);
                req.print();
        endtask
endclass 

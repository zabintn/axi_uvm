class axi_reset_sequence extends axi_base_sequence;
        `uvm_object_utils(axi_reset_sequence)

        function new(string name= "axi_reset_sequence");
                super.new(name);
        endfunction

        task body(); 
		axi_seq_item rs;
		super.body();
                rs=axi_seq_item::type_id::create("rs");
		start_item(rs);
		rs.randomize with {
			aresetn== 1'b0;
			};
                finish_item(rs);
                rs.print();
        endtask
endclass 

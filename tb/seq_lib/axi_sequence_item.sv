class axi_seq_item extends uvm_sequence_item;

	 rand bit axi_op;
	 rand bit aresetn;
	 //AW CHANNEL
	 rand bit [ADDR_WIDTH-1:0]   awaddr;
	 randc bit [ID_WIDTH-1:0]    awid;
	 rand bit [LEN_WIDTH-1:0]    awlen;
	 rand bit [SIZE_WIDTH-1:0]   awsize;
	 rand bit [BURST_TYPE-1:0]   awburst;
	 
	 
	 rand bit [DATA_WIDTH-1:0]   wdata[];
	 rand bit [DATA_WIDTH/8-1:0] wstrb[];
	 
	 rand bit [ADDR_WIDTH-1:0]   araddr;
	 randc bit [ID_WIDTH-1:0]    arid;
	 rand bit [LEN_WIDTH-1:0]    arlen;
	 rand bit [SIZE_WIDTH-1:0]   arsize;
	 rand bit [BURST_TYPE-1:0]   arburst;
	 
	 
	`uvm_object_utils_begin(axi_seq_item)
	`uvm_field_int(axi_op, UVM_ALL_ON)
	`uvm_field_int(awaddr, UVM_ALL_ON)
	`uvm_field_int(awid, UVM_ALL_ON)
	`uvm_field_int(awlen, UVM_ALL_ON)
	`uvm_field_int(awburst, UVM_ALL_ON)
	`uvm_field_int(awsize, UVM_ALL_ON)
	`uvm_field_array_int(wdata, UVM_ALL_ON)
	`uvm_field_array_int(wstrb, UVM_ALL_ON)
	`uvm_field_int(araddr, UVM_ALL_ON)
	`uvm_field_int(arid, UVM_ALL_ON)
	`uvm_field_int(arlen, UVM_ALL_ON)
	`uvm_field_int(arburst, UVM_ALL_ON)
	`uvm_field_int(arsize, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="axi_seq_item");
		super.new(name);
	endfunction
endclass

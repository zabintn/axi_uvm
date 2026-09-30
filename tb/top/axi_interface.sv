import axi_param_pkg::*;
interface axi_if(input bit clk);
	logic aresetn;

	//aw channel
	logic [ADDR_WIDTH-1:0] awaddr;
	logic [ID_WIDTH-1:0] awid;
	logic [LEN_WIDTH-1:0] awlen;
	logic [SIZE_WIDTH-1:0] awsize;
	logic [BURST_TYPE-1:0] awburst;
	logic awvalid;
	logic awready;

	//w channel
	
	logic [DATA_WIDTH-1:0] wdata;
	logic [(DATA_WIDTH/8)-1:0] wstrb;
	logic wlast;
	logic wvalid;
	logic wready;

	//b channel
	
	logic [ID_WIDTH-1:0] bid;
	logic [1:0] bresp;
	logic bvalid;
	logic bready;

	//ar channel

	logic [ID_WIDTH-1:0] arid;
	logic [ADDR_WIDTH-1:0] araddr;
	logic [LEN_WIDTH-1:0] arlen;
	logic [SIZE_WIDTH-1:0] arsize;
	logic [BURST_TYPE-1:0] arburst;
	logic arvalid;
	logic arready;

	//r channel
	//
	logic [ID_WIDTH-1:0] rid;
	logic [DATA_WIDTH-1:0] rdata;
	logic [1:0] rresp;
	logic rlast;
	logic rvalid;
	logic rready;

endinterface


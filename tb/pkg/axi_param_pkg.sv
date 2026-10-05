package axi_param_pkg;

	parameter int DATA_WIDTH=64;
	parameter int ADDR_WIDTH=32;
	parameter int ID_WIDTH=4;
	parameter int LEN_WIDTH  = 8;
	parameter int SIZE_WIDTH = 3;
	parameter int BURST_TYPE = 2;
	parameter logic [ADDR_WIDTH-1:0] ADDRESS_CEIL=32'hFFFF_FFFF;
endpackage


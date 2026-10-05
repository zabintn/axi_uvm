# ----------------------------------------
# Vivado xsim-based Makefile
# Compile -> Elaborate -> Simulate flow
# ----------------------------------------

TEST ?= axi_base_test
UVM_VERBOSITY ?= UVM_MEDIUM
SEED ?= random
CLK_FREQUENCY ?= 100

RTL_DIR   = ../rtl
TB_DIR    = .
SIM_DIR   = .

TOP       = axi_tb_top
SNAPSHOT  = axi_tb_top_snap
TIMESCALE = 1ns/1ps
RTL_SRC   = $(RTL_DIR)/apb_v3_sram.sv
TB_SRC    = $(TB_DIR)/compile.f
.PHONY: compile elaborate simulate run clean

# Step 1: Compile RTL + testbench sources
compile:
	xvlog --sv $(RTL_SRC) -f $(TB_SRC) \
		-L uvm

# Step 2: Elaborate design into a simulation snapshot
elaborate: compile
	xelab $(TOP) -timescale=$(TIMESCALE) -s $(SNAPSHOT) \
		-L uvm -debug typical

# Step 3: Run simulation:
simulate: elaborate
	xsim $(SNAPSHOT) -runall \
		-testplusarg "UVM_TESTNAME=$(TEST)" \
		-testplusarg "UVM_VERBOSITY=$(UVM_VERBOSITY)"\
                -testplusarg "CLK_FREQUENCY=$(CLK_FREQUENCY)"\
		-log xsim_$(TEST).log

gui_sim: elaborate
	xsim $(SNAPSHOT) -gui \
		-testplusarg "UVM_TESTNAME=$(TEST)" \
		-testplusarg "UVM_VERBOSITY=$(UVM_VERBOSITY)"\
                -testplusarg "CLK_FREQUENCY=$(CLK_FREQUENCY)"\
		-log xsim_$(TEST).log

# Convenience target: does all three in order
all: compile elaborate simulate
allg: compile elaborate gui_sim

clean:
	rm -rf xsim.dir *.log *.jou *.pb *.wdb .Xil xelab.pb webtalk* 

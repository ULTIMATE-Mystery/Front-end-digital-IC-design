##################################################################################################
# This file created by Pham Duy Quang
# Updated date: 25/12/2024
# Example run string: make TESTNAME={name_of_testcase} {optional}
#		      make TESTNAME=counter_test all 
##################################################################################################
#Define variables
TESTNAME 	?= test_adder
TB_NAME 	?= test_bench
RADIX		?= decimal
MEALY_FSM   ?= 0
STR_LEN     ?= 32

#==============================
all: build run

all_wave: build run wave

build:
	vlib work
	vmap work work
	vlog  -f compile.f | tee compile.log
run:
	vsim -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "log -r /*;run -all;" -GMEALY_FSM=$(MEALY_FSM) -GSTR_LEN=$(STR_LEN)
wave:
	vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)" &
clean:
	rm -rf work
	rm -rf vsim.dbg
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
help:
	@echo ""
	@echo "****************************************"
	@echo "** make clean: clean all compiled data"
	@echo "** make build: build the design"
	@echo "** make run  : run simulation"
	@echo "** make all  : build and run simulation"
	@echo "** make wave : open waveform"
	@echo "** Parameters:"
	@echo "**   MEALY_FSM={0|1} : Select FSM type"
	@echo "**   STR_LEN={num}   : Set stream length"
	@echo "****************************************"
	@echo ""
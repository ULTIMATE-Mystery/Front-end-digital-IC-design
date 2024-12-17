##################################################################################################
#This file created by Huy Nguyen
#This file is updated by Quang Pham
#Updated date: 9/27/2024
#Example run string: make TESTNAME={name_of_testcase} {optional}
#		     make TESTNAME=counter_test all 
##################################################################################################
#Define variables
TESTNAME 	?= test_adder
TB_NAME 	?= test_bench
RADIX		?= decimal

#==============================
build:
	vlib work
	vmap work work
	vlog -sv -f compile.f | tee compile.log
run:
	vsim -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "log -r /*;run -all;"
wave:
	vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)" &

help:
	@echo "****************************************"
	@echo "** make clean: clean all compiled data"
	@echo "** make build: build the design"
	@echo "** make run  : run simulation"
	@echo "** make all  : build and run simulation"
	@echo "** make wave : open waveform"
	@echo "****************************************"

clean:
	rm -rf work *.log *.wlf transcript modelsim.ini vsim.dbg

all:	build run

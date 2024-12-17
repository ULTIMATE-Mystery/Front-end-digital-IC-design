##################################################################################################
#This file created by Huy Nguyen
#Updated date: 6/30/2019
#Example run string: make TESTNAME={name_of_testcase} {optional}
#		     make TESTNAME=counter_test all 
##################################################################################################
#Define variables
TESTNAME 	?= test_adder
TB_NAME 	?= test_bench
RADIX		?= decimal

#==============================
all: build run

build:
	vlib work
	vmap work work
	vlog -f compile.f | tee compile.log
run:
	vsim -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "log -r /*;run -all;"
wave:
	vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)" &
clean:
	rm -rf work
	rm -rf vsim.dbg
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript

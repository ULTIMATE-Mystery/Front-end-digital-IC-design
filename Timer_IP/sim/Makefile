# Define variables
TESTNAME ?= apb_protocol_chk
TB_NAME  ?= testbench
RADIX    ?= decimal
REGRESS_LIST ?= pat.list

# Targets
all: build run

all_wave: build run wave

all_cov: build_cov run_cov

# Build design
build:
	mkdir -p log
	cp -rf ../testcases/$(TESTNAME).v run_test.v
	vlib work
	vmap work work
	vlog -f compile.f | tee compile.log

# Build with coverage enabled
build_cov:
	mkdir -p log
	cp -rf ../testcases/$(TESTNAME).v run_test.v
	vlib work
	vmap work work
	vlog +cover=bcesft -f compile.f

# Run simulation
run:
	vsim -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) -do "log -r /*;run -all;"
	cp $(TESTNAME).log ./log
	mv $(TESTNAME).log sim.log

# Run simulation with coverage
run_cov:
	vsim -coverage -l $(TESTNAME).log -c $(TB_NAME) -voptargs=+cover=bcesft -assertdebug -do "coverage save -onexit $(TESTNAME).ucdb; log -r /*;run -all"
	cp $(TESTNAME).log ./log
	mv $(TESTNAME).log sim.log

# View waveform
wave:
	vsim -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)" &

# Generate coverage report
gen_cov:
	mkdir -p coverage
	vcover merge IP.ucdb *.ucdb
	vcover report IP.ucdb -output coverage/summary_report.txt
	vcover report -zeros -details -code bcesft -annotate -ALL -codeALL IP.ucdb -output coverage/detail_report.txt

# Generate HTML coverage report
gen_html:
	mkdir -p coverage
	vcover merge IP.ucdb *.ucdb
	vcover report -zeros -details -code bcesft -annotate -testhitdataALL -html IP.ucdb

# Clean all compiled data
clean:
	rm -rf work
	rm -rf vsim.dbg
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
	rm -rf *.ucdb
	rm -rf run_test.v

# Help command
help:
	@echo "****************************************"
	@echo "** make clean   : clean all compiled data"
	@echo "** make build   : build the design"
	@echo "** make run     : run simulation"
	@echo "** make all     : build and run simulation"
	@echo "** make wave    : open waveform"
	@echo "** make gen_cov : generate coverage report"
	@echo "** make gen_html: generate HTML coverage report"
	@echo "****************************************"
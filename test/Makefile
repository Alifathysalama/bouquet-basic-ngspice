TOP?=basic.cir

BASE_NAME=$(basename $(TOP))
SPICE_FILE=$(realpath $(TOP))
SPICE_NAME=$(basename $(notdir $(SPICE_FILE)))

RAW_FILE=$(SPICE_NAME).raw

all: print

print:
	@echo BASE_NAME:  $(BASE_NAME)
	@echo SPICE_FILE:   $(SPICE_FILE)
	@echo SPICE_NAME:   $(SPICE_NAME)
	@echo RAW_FILE:   $(RAW_FILE)


test-env-py:
	python3 eval.py $(BASE_NAME)


sim:
	SPICE_USERINIT_DIR=. ngspice -b -o $(SPICE_NAME).log -r $(RAW_FILE) -a $(SPICE_NAME).cir


test-all:
	make TOP=basic.cir test-env-py
	make TOP=tt07-analog-dac-ay8913/xschem/simulation/testbench_dac_16nfet.spice test-env-py


sim-all:
	make TOP=basic.cir sim

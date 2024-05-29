TOP?=basic.spice
SPICE_FILE=$(realpath $(TOP))
BASE_NAME=$(basename $(TOP))

SPICE_NAME=$(basename $(notdir $(SPICE_FILE)))

RAW_FILE=$(SPICE_NAME).raw

all: print

print:
	@echo TOP: ............... $(TOP)
	@echo SPICE_FILE: ........ $(SPICE_FILE)
	@echo BASE_NAME: ......... $(BASE_NAME)
	@echo SPICE_NAME: ........ $(SPICE_NAME)
	@echo RAW_FILE: .......... $(RAW_FILE)


test-env-py:
	python3 eval.py $(RAW_FILE)


sim:
	SPICE_USERINIT_DIR=. ngspice -b -o $(SPICE_NAME).log -r $(RAW_FILE) -a $(SPICE_FILE)


assert:
	grep "$(PATTERN)" $(FILE)


test-basic:
	make TOP=basic/basic.spice sim
	make TOP=basic/basic.spice test-env-py

test-sky130:
	PDK=sky130A PDK_ROOT=/opt/pdks make TOP=sky130/oscillator.spice sim
	make FILE=oscillator.log PATTERN="freq = 1.381854e+08" assert

test-ihp:
	PDK=sg13g2 PDK_ROOT=/opt/pdks make TOP=ihp/test.spice sim
	exit 0

test-all:
	
	make TOP=tt07-analog-dac-ay8913/xschem/simulation/testbench_dac_16nfet.spice test-env-py

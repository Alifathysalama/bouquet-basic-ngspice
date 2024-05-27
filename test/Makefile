TOP?=basic.cir

CIR_FILE=$(realpath $(TOP))
CIR_NAME=$(basename $(notdir $(CIR_FILE)))

RAW_FILE=$(CIR_NAME).raw

all:
	print $(CIR_NAME)
	#cat $(TOP)


test:
	python3 eval.py $(CIR_NAME)


sim:
	SPICE_USERINIT_DIR=. ngspice -b -o $(CIR_NAME).log -r $(RAW_FILE) -a $(CIR_NAME).cir
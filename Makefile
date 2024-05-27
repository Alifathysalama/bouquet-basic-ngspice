all:
	@echo Nothing selected

NPROC=$(shell nproc)

NGSPICE_FLAGS= \
	--disable-debug \
    --enable-openmp \
    --with-x \
    --with-readline=yes \
    --enable-pss \
    --enable-xspice \
    --with-fftw3=yes \
    --enable-osdi \
    --enable-klu

NGSPICE_DIR=$(realpath ngspice)
NGSPICE_RELEASE_DIR=$(NGSPICE_DIR)/release
NGSPICE_RELEASE_LIB_DIR=$(NGSPICE_DIR)/release-lib

NGSPICE_REPO=git://git.code.sf.net/p/ngspice/ngspice

NGSPICE_MAKEFILE=$(NGSPICE_DIR)/Makefile


NGSPICE_PREFIX="opt/ngspice/"

AGENT_IMAGE_NAME=akilesalreadytaken/gocd-agent-ngspice:latest

clone-ngspice:
	git clone $(NGSPICE_REPO) || true
	cd $(NGSPICE_DIR) && git pull


build-ngspice:
	mkdir -p $(NGSPICE_RELEASE_DIR)
	cd $(NGSPICE_RELEASE_DIR) && make distclean || true

	#FIXME 2 runs of autogen needed
	cd $(NGSPICE_DIR) && $(NGSPICE_DIR)/autogen.sh
	cd $(NGSPICE_DIR) && $(NGSPICE_DIR)/autogen.sh

	cd $(NGSPICE_RELEASE_DIR) && $(NGSPICE_DIR)/configure $(NGSPICE_FLAGS) CFLAGS="-m64 -O2" LDFLAGS="-m64 -s"
	cd $(NGSPICE_RELEASE_DIR) && make -j"$(NPROC)" 2>&1 | tee make.log


build-ngspice-lib:
	mkdir -p $(NGSPICE_RELEASE_LIB_DIR)
	cd $(NGSPICE_RELEASE_LIB_DIR) && make distclean || true

	#FIXME 2 runs of autogen needed
	cd $(NGSPICE_DIR) && $(NGSPICE_DIR)/autogen.sh
	cd $(NGSPICE_DIR) && $(NGSPICE_DIR)/autogen.sh

	cd $(NGSPICE_RELEASE_LIB_DIR) && $(NGSPICE_DIR)/configure $(NGSPICE_FLAGS) CFLAGS="-m64 -O2" LDFLAGS="-m64 -s"
	cd $(NGSPICE_RELEASE_LIB_DIR) && make -j"$(NPROC)" 2>&1 | tee make.log


test-ngspice:
	cd $(NGSPICE_RELEASE_DIR) && make check


build-agent:
ifeq (,$(DOCKER_TARGET))
	docker build . -t $(AGENT_IMAGE_NAME)
else
	docker build --target $(DOCKER_TARGET) . -t $(AGENT_IMAGE_NAME)
endif

AGENT_RUN_CMD=docker run -it --rm --mount type=bind,source=$(realpath ./test),target=/home/go/test
start-agent:
	$(AGENT_RUN_CMD) $(AGENT_IMAGE_NAME) bash

start-agent-root:
	$(AGENT_RUN_CMD) --user root $(AGENT_IMAGE_NAME) bash

start-updated-agent: build-agent start-agent

test-agent:
	$(AGENT_RUN_CMD) $(AGENT_IMAGE_NAME) bash -c "cd $$HOME/test && make test"
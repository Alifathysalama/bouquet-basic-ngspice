
all:
	@echo Nothing selected

TIMESTAMP_DAY=$(shell date +%Y_%m_%d)
TIMESTAMP_TIME=$(shell date +%H_%M_%S)

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

ifneq (,DOCKER_ROOT)
DOCKER_ROOT_USER=--user root
endif

ifeq (Windows_NT,$(OS))
DOCKER_SOCKET=//var/run/docker.sock
else
DOCKER_SOCKET=/var/run/docker.sock
endif

DOCKER_RUN_AGENT=docker run -it --rm --mount type=bind,source=$(realpath ./test),target=/home/go/test $(DOCKER_ROOT_USER)
DOCKER_RUN_DIND=$(DOCKER_RUN_AGENT) --privileged -v $(DOCKER_SOCKET):/var/run/docker.sock
DOCKER_IMAGE_AGENT=akilesalreadytaken/gocd-agent-ngspice:latest
DOCKER_IMAGE_DIND=akilesalreadytaken/gocd-agent-dind:latest

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

########################
# Ngspice Agent Commands
########################


build-agent:
ifeq (,$(DOCKER_TARGET))
	docker build . -t $(DOCKER_IMAGE_AGENT)
else
	docker build --target $(DOCKER_TARGET) . -t $(DOCKER_IMAGE_AGENT)
endif


build-agent-gocd:
	docker build -f Dockerfile . -t $(TIMESTAMP_DAY)_$(TIMESTAMP_TIME) -t latest


start-agent:
	$(DOCKER_RUN_AGENT) $(DOCKER_IMAGE_AGENT) bash -c "cd /home/go/; bash"


start-agent-root:
	$(DOCKER_RUN_AGENT) --user root $(DOCKER_IMAGE_AGENT) bash


start-updated-agent: build-agent start-agent


test-agent:
	$(DOCKER_RUN_AGENT) $(DOCKER_IMAGE_AGENT) bash -c "cd $$HOME/test && make test"


########################
# Docker in Docker Agent
########################


build-dind:
ifeq (,$(DOCKER_TARGET))
	docker build -f Dockerfile.dind . -t $(DOCKER_IMAGE_DIND)
else
	docker build -f Dockerfile.dind --target $(DOCKER_TARGET) . -t $(DOCKER_IMAGE_DIND)
endif


start-dind:
	$(DOCKER_RUN_DIND) $(DOCKER_IMAGE_DIND) bash


start-dind-root:
	$(DOCKER_RUN_DIND) --user root $(DOCKER_IMAGE_DIND) bash

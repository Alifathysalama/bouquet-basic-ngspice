ARG NGSPICE_REPO_URL="https://github.com/danchitnis/ngspice-sf-mirror" \
    NGSPICE_REPO_COMMIT="ngspice-42" \
    NGSPICE_NAME="ngspice"

#######################################################################
# Setup base image
#######################################################################
ARG BASE_IMAGE=gocd/gocd-agent-ubuntu-24.04:v24.1.0
FROM ${BASE_IMAGE} as base
ARG CONTAINER_TAG=unknown
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Vienna \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TOOLS=/opt \
    PDK_ROOT=/opt/pdks

USER root

RUN --mount=type=bind,source=images/base,target=/images/base \
    bash /images/base/base_install.sh

#######################################################################
# Compile ngspice
#######################################################################
FROM base as ngspice

ARG NGSPICE_REPO_URL \
    NGSPICE_REPO_COMMIT \
    NGSPICE_NAME

RUN --mount=type=bind,source=images/ngspice,target=/images/ngspice \
    bash /images/ngspice/install.sh

#######################################################################
# Final output container
#######################################################################
FROM base as gocd-agent-ngspice

ARG NGSPICE_REPO_URL \
    NGSPICE_REPO_COMMIT \
    NGSPICE_NAME

COPY --from=ngspice   ${TOOLS}/   ${TOOLS}/

ENV PATH=${PATH}:${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}/bin \
    LD_LIBRARY_PATH=${TOOLS}/${NGSPICE_NAME}/${NGSPICE_REPO_COMMIT}/lib

USER go
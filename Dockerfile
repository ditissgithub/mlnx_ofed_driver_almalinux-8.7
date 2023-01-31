#ARG D_BASE_IMAGE=registry.access.redhat.com/ubi7:latest
FROM almalinux:8.7

ARG D_OFED_VERSION="5.8-1.1.2.1"
ARG D_OS_VERSION="8.7"
ARG D_OS="rhel${D_OS_VERSION}"
ENV D_OS=${D_OS}
ARG D_ARCH="x86_64"
ARG D_OFED_PATH="MLNX_OFED_LINUX-${D_OFED_VERSION}-${D_OS}-${D_ARCH}"
ENV D_OFED_PATH=${D_OFED_PATH}

ARG D_OFED_TARBALL_NAME="${D_OFED_PATH}.tgz"
#ARG D_OFED_BASE_URL="https://www.mellanox.com/downloads/ofed/MLNX_OFED-${D_OFED_VERSION}"
ARG D_OFED_BASE_URL="https://content.mellanox.com/ofed/MLNX_OFED-${D_OFED_VERSION}"
ARG D_OFED_URL_PATH="${D_OFED_BASE_URL}/${D_OFED_TARBALL_NAME}"
ARG D_WITHOUT_FLAGS="--without-rshim-dkms --without-iser-dkms --without-isert-dkms --without-srp-dkms --without-kernel-mft-dkms --without-mlnx-rdma-rxe-dkms"
ENV D_WITHOUT_FLAGS=${D_WITHOUT_FLAGS}


RUN yum install dnf -y
# Download and extract tarball
WORKDIR /root


RUN yum install -y kernel-core-4.18.0-425.3.1.el8.x86_64 \
kernel-4.18.0-425.3.1.el8.x86_64 \
kernel-modules-4.18.0-425.3.1.el8.x86_64 \
kernel-tools-4.18.0-425.3.1.el8.x86_64 \
kernel-tools-libs-4.18.0-425.3.1.el8.x86_64 \
libusbx numactl-libs libnl3 gcc-gfortran fuse-libs tcsh createrepo wget kernel-devel kernel-headers kernel-modules-extra pkgconf-pkg-config platform-python-devel

RUN yum install -y  python2-devel python2
#RUN yum -y install curl && (curl ${D_OFED_URL_PATH} | tar -xzf -)
RUN yum -y install autoconf automake binutils ethtool gcc git hostname kmod libmnl libtool lsof make pciutils perl procps python36 python36-devel rpm-build tcl tk wget


RUN yum -y install curl && (curl ${D_OFED_URL_PATH} | tar -xzf -)



WORKDIR /
ADD ./entrypoint.sh /root/entrypoint.sh

RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]

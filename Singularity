BootStrap: docker
From: rockylinux:9

%post
# update and requirements for miniconda
yum -y update && \
dnf install -y 'dnf-command(config-manager)' && \
dnf config-manager --set-enabled crb && \
yum -y install epel-release && \
yum -y update && \
yum -y groupinstall base-x && \
dnf -y install \
	automake \
	bison \
	bzip2 \
	cmake \
	elfutils-libelf-devel \
	environment-modules \
	fftw-devel \
	file \
	flex \
	gcc \
	gcc-c++ \
	ghostscript \
	git \
	hdf5-devel \
	java-17-openjdk-devel \
	libglvnd-opengl \
	libpng-devel \
	libtiff-devel \
	libX11-devel \
	libXft-devel \
	libxkbcommon \
	libxkbcommon-x11 \
	libzstd-devel \
	make \
	openmpi \
	openmpi-devel \
	pciutils \
	rsync \
	tar \
	tcsh \
	unzip \
	wget \
	which \
	&& \
dnf config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/rhel9/$(uname -i)/cuda-rhel9.repo && \
yum -y update && \
dnf -y install \
	cuda-minimal-build-12-4.x86_64 \
	libcufft-devel-12-4.x86_64 \
	libcurand-devel-12-4.x86_64 \
	cuda-nvtx-12-4.x86_64 \
	libcublas-devel-12-4.x86_64 \
	cuda-nvml-devel-12-4.x86_64 \
	&& \
yum -y clean all

mkdir -p /local/scratch/tmp # for maestro $TMPDIR

# install miniconda
#
cat <<EOF > /00_install_miniconda_scipion-installer.sh
#/bin/bash
curl -qsSLkO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
&& bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 \
&& rm Miniconda3-latest-Linux-x86_64.sh
/opt/miniconda3/bin/conda update --yes conda && /opt/miniconda3/bin/conda update --all --yes

# mpi
unset module || :
. /etc/profile.d/modules.sh
module use /usr/share/modulefiles/
module add mpi/openmpi-x86_64

# cuda
PATH=/usr/local/cuda/bin:/opt/scipion:/opt/miniconda3/bin:/usr/local/bin:\$PATH
export PATH

conda update --yes -n base -c defaults conda && \
conda update --yes --all
bash -c 'eval "\$(conda shell.bash hook)" && \
conda activate && \
python3 -m pip install scipion-installer scons'

# cleanup
conda clean --all --yes
EOF
chmod 755 /00_install_miniconda_scipion-installer.sh


%environment
PATH=/usr/local/cuda/bin:/opt/scipion:/opt/miniconda3/bin:/usr/local/bin:$PATH
export PATH

%runscript 
#!/bin/bash
# mpi
unset module || :
. /etc/profile.d/modules.sh
module use /usr/share/modulefiles/
module add mpi/openmpi-x86_64
# cuda
PATH=/usr/local/cuda/bin:/opt/scipion:/opt/miniconda3/bin:/usr/local/bin:$PATH
export PATH

[ -f /opt/miniconda3/bin/conda ] && \
	eval "$(/opt/miniconda3/bin/conda shell.bash hook)" && echo "conda initialised" 
[ -d /opt/miniconda3/envs/scipion3/ ]  && [ -d /opt/scipion/software/em/ ] && \
	conda activate scipion3 && echo "scipion3 environment activated" && \
	eval "$@"

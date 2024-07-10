#!/bin/bash
set -e
set -u
set -o pipefail

tbindir=$(mktemp -d)
trap "rm -rf \"$tbindir\"" TERM INT EXIT

$(command -v readlink 2>&1 >> /dev/null)  && script_path=$(dirname "$(readlink -f "$BASH_SOURCE")")
echo "${script_path}"

# path to the container sif file (created if if not there by apptainer build...
_S=rl9-scipion-runtime-cuda124-2024-07-10-0023.sif    
# path to the scipion read-only squashfs file (read-only once created)
_A=rl9-cuda124--20240619-opt.sqfs
# path to the read-write folder where scipion3/conda live
_B=/dev/shm/opt-rl9-cuda124

# apptainer flags examples
_F=""
# nvidia
_F="--nv ${_F}"
# mount /run
_F="-B /run  ${_F}"
# mount _A as /opt in the container
#_F=" -B ${_A}:/opt:image-src=. ${_F}"
# mount _B as /opt
_F="-B ${_B}:/opt ${_F}"

# specific to our campus
_F="-B /local -B /pasteur  ${_F}"

# clean HOME/ephemeral HOME
#comment if you want to use your actual HOME
_H=`mktemp -d`
_F="-H ${_H} ${_F}"

# more environment for the container:
export IMOD_DIR=/opt/scipion/software/em/imod-4.11.25/imod_4.11.25/
_env="--env \"IMOD_DIR=$IMOD_DIR\" "
_F="${_env} ${_F}"


[ -d ${_B}/miniconda3/envs/scipion3/ ]  && [ -d ${_B}/scipion/software/em/ ] && \
	 apptainer run  ${_F} ${_S} bash


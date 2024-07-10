# building a RockyLinux9 based singularity/apptainer container for scipion3 (using cuda 12.4)

Tru <tru@pasteur.fr>

## Why ?
- ready to use runtime environment for scipion3
- just add miniconda and scipion3 (use a writable bind mount for /opt)
- allow easy snapshoting/replacement for /opt and upgrade/downgrade
- share scipion with your co-worker
- As of 2024/07, RockyLinux 9 is version 9.4 and Cuda >=12.4 supports gcc 11.4.1 (https://docs.nvidia.com/cuda/archive/12.4.1/cuda-installation-guide-linux/index.html). Cuda 12.3.x on rl9 is listing gcc 11.3.1 only (https://docs.nvidia.com/cuda/archive/12.3.2/cuda-installation-guide-linux/index.html)

## How to:
- build the container
- use the container with a mounted /opt to
	- install miniconda and scipion-installer
	- install any plugin/binary
- use mksquashfs "freeze" your scipion and share it with the rl9 runtime

## helper scripts (read and modify to your needs especially `_S` and `_B`)
- `setup.sh` build the container and install scipion3 conda environment
- `scipion3.sh` run scipion3 from the container

## use the artefact produced on github instead of building your own:
```
apptainer build ghrc-io-singularity-rl9-scipion-runtime-cuda124.sif oras://ghcr.io/truatpasteurdotfr/singularity-rl9-scipion-runtime-cuda124:latest
```

## References
- https://scipion.i2pc.es/

## Caveat
- playground, use at your own risk!


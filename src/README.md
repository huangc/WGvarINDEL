src/* directory contains prerequisite softwares:
- blat
- blast+

WGvarINDEL is implemented as a collection of shell scripts and ancillary Python codes, so no compilation is required. However, the workflow depends on several third-party programs, and many of which do require compiling and/or additional configuration for your particular system. Please see the cited URLs below for details on the software installation. *src/* is assumed for the installation path, but should be replaced with the actual path.

In the case on the IU Mason cluster, the prerequisite softwares can be loaded from the system:
- module add blat

### Blat
See http://bio-bwa.sourceforge.net.
Last update: December 3, 2015.
```bash
cd ${src_DIR}
wget https://github.com/lh3/bwa/archive/0.7.12.tar.gz
tar -xzf 0.7.12.tar.gz
cd bwa-0.7.12/
make
cp bwa ${bin_DIR}
```

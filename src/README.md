## *src/* directory contains prerequisite softwares:
- blat
- blast+

WGvarINDEL is implemented as a collection of shell scripts and ancillary Python codes, so no compilation is required. However, the workflow depends on several third-party programs, and many of which do require compiling and/or additional configuration for your particular system. Please see the cited URLs below for details on the software installation. *src/* is assumed for the installation path, but should be replaced with the actual path.

In the case on the IU Mason cluster, the prerequisite softwares can be loaded from the system:
- module add blat

### Blat
See https://genome.ucsc.edu/FAQ/FAQblat.html
Last update: February 18, 2016.
```bash
cd ${src_DIR}
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/blat/blat
chmod u+x blat
```

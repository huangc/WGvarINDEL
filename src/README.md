## *src/* directory contains prerequisite softwares:
- blat
- blast+

WGvarINDEL is implemented as a collection of shell scripts and ancillary Python codes, so no compilation is required. However, the workflow depends on several third-party programs, and many of which do require compiling and/or additional configuration for your particular system. Please see the cited URLs below for details on the software installation. *src/* is assumed for the installation path, but should be replaced with the actual path.

In the case on the IU Mason cluster, the prerequisite softwares can be loaded from the system:
- module add blat

### Blat
See https://genome.ucsc.edu/FAQ/FAQblat.html
Last update: April 18, 2012
```bash
cd ${src_DIR}
mkdir blat34
cd blat34
wget http://hgwdev.cse.ucsc.edu/~kent/exe/linux/blatSuite.34.zip
unzip blatSuite.34.zip
```

### BLAST
See https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download
Last update:    March 8, 2015
```bash
cd ${src_DIR}
mkdir blast
cd blast
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.30/ncbi-blast-2.2.30+-x64-linux.tar.gz
tar -xzf ncbi-blast-2.2.30+-x64-linux.tar.gz
```

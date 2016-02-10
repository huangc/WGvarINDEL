## Prerequisite data:
* Run TRegGA workflow to obtain the soapdenovo2-assembled contigs (and scaffolds) of rice samples. Only contigs are used in the current workflow.
* Retrieve the reference rice Japonica sequence and gff3 files.

## Prerequisite software:
* NCBI BLAST+
* BLAT (The BLAST-Like Alignment Tool)
* getTarget.py from TRegGA #with modification to retrieve fasta instead of embl
* xgetseq from TRegGA #with modification to retrieve also individual chrs

```
source 0SOURCE
cd ${TALEN_DIR}
mkdir -p ${TALEN_DIR}/bin
cd ${TALEN_DIR}/bin
```

### getTarget.py - python script for retrieving sequence by range (ref: TRegGA getTarget.py)
```
#!/usr/bin/python

import sys
from Bio import SeqIO

infile = sys.argv[1]
slabel = sys.argv[2]
frompos = sys.argv[3]
topos = sys.argv[4]

record = SeqIO.read(infile, "fasta")
sub_record = record[int(frompos):int(topos)]

SeqIO.write(sub_record, slabel + ".fasta", "fasta")
```

### xgetseq - python script for retrieving reference sequences (ref: TRegGA xgetseq)
```
#!/usr/bin/env bash
set -exo pipefail

# 0. Check for software prerequisites:
which makeblastdb
which gt
which blastdbcmd

# 1. Retrieve Oryza sativa japonica (Osj) sequences from Ensembl:
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-26/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.26.dna.genome.fa.gz
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-26/embl/oryza_sativa/Oryza_sativa.IRGSP-1.0.26.dat.gz
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-26/gff3/oryza_sativa/Oryza_sativa.IRGSP-1.0.26.gff3.gz
gunzip -f *.gz
mv Oryza_sativa.IRGSP-1.0.26.dat Oryza_sativa.IRGSP-1.0.26.embl

# 2. Add the label "OsjChr" to the chromosome sequence names so that ">1" becomes ">OsjChr1", etc.:
sed -i -e "s/^>\([1-9]\)/>OsjChr\1/" Oryza_sativa.IRGSP-1.0.26.dna.genome.fa

# 3. Create BLAST databases for the genome sequences:
makeblastdb -in Oryza_sativa.IRGSP-1.0.26.dna.genome.fa -dbtype nucl -parse_seqids -out OsjDNA

# 4. Extract the chromosome sequences into file OsjCHR.fa:
blastdbcmd -db OsjDNA -entry OsjChr1,OsjChr2,OsjChr3,OsjChr4,OsjChr5,OsjChr6,OsjChr7,OsjChr8,OsjChr9,OsjChr10,OsjChr11,OsjCh\
r12 \
    | sed "s/^>lcl|/>/;" \
    > OsjCHR.fa
```

### Use TRegGA workflow to obtain the soapdenovo2-assembled contigs and scaffolds of rice samples
Note: here the contigs were assembled previously, and we are just retrieving those contig files.
```
cd ${TALEN_DIR}
mkdir -p ${prereq_DIR}
cd ${prereq_DIR}

for i in ${SAMPLE}
do
scp userID@mason.indiana.edu:/N/dc2/projects/brendelgroup/TRegGA/TRegGA_v1/assembly/denovo/${i}/${i}-soap.contig .
makeblastdb -in ${i}-soap.contig -dbtype nucl -out DB_${i}_contig -parse_seqids
done
```

### Retrieve the rice Japonica sequences and gff3 file
```
wget ftp://ftp.plantbiology.msu.edu/pub/data/Eukaryotic_Projects/o_sativa/annotation_dbs/pseudomolecules/version_7.0/all.dir\
/all.gff3
wget ftp://ftp.plantbiology.msu.edu/pub/data/Eukaryotic_Projects/o_sativa/annotation_dbs/pseudomolecules/version_7.0/all.dir\
/all.chrs.con
mv all.gff3 ${REFGFF}
mv all.chrs.con ${REFSEQ}
```
### Generate blastdb for the whole genome of the reference rice.
```
makeblastdb -in ${REFSEQ} -dbtype nucl -out DB_${REFNAME} -parse_seqids
```

### Retrieve the rice Japonica individual chromosomes
Note the chr name is in this convention >Chr1
```
for i in {1..12}
do
blastdbcmd -db ${prereq_DIR}/DB_${REFNAME} -entry "lcl|Chr${i}" -dbtype nucl -outfmt "%f" -out OsjChr${i}.fa
sed -i -e "s/>lcl|/>/" OsjChr${i}.fa
done
```


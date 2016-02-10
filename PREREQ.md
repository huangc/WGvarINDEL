## Prerequisite data:
* Run TRegGA workflow to obtain the soapdenovo2-assembled contigs (and scaffolds) of rice samples. Only contigs are used in the current workflow.
* Retrieve the reference rice Japonica sequence and gff3 files.

## Prerequisite software:
* NCBI BLAST+
* BLAT (The BLAST-Like Alignment Tool)
* getTarget.py from TRegGA #with modification to retrieve fasta instead of embl
* xgetseq from TRegGA #with modification to retrieve also individual chrs

## Setup sub-directory for workflow
```
source 0SOURCE
cd ${WORK_DIR}
mkdir -p ${WORK_DIR}/prereq
mkdir -p ${WORK_DIR}/doc
mkdir -p ${WORK_DIR}/bin
mkdir -p ${WORK_DIR}/src
mkdir -p ${WORK_DIR}/run
mkdir -p ${WORK_DIR}/data
mkdir -p ${WORK_DIR}/scratch
```

### Use TRegGA workflow to obtain the soapdenovo2-assembled contigs and scaffolds of rice samples
Note: here the contigs were assembled previously, and we are just retrieving those contig files.
```
cd ${WORK_DIR}
mkdir -p ${prereq_DIR}
cd ${prereq_DIR}

for i in ${SAMPLE}
do
scp ${mason_UID}:${denovo_DIR}/${i}/${i}-soap.contig .
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

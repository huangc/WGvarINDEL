#!/bin/bash
source ./0SOURCE

## Prerequisite data:
# Run TRegGA workflow to obtain the soapdenovo2-assembled contigs (and scaffolds) of rice samples. Only contigs are used in the current workflow.
# Retrieve the reference rice Japonica sequence and gff3 files.

## Prerequisite software:
# NCBI BLAST+
# BLAT (The BLAST-Like Alignment Tool)
# getTarget.py from TRegGA #with modification to retrieve fasta instead of embl
# xgetseq from TRegGA #with modification to retrieve also individual chrs

##--------------------------------------------
# Setup sub-directory for workflow
cd ${WORK_DIR}
mkdir -p ${WORK_DIR}/prereq
mkdir -p ${WORK_DIR}/doc
mkdir -p ${WORK_DIR}/bin
# mkdir -p ${WORK_DIR}/src
mkdir -p ${WORK_DIR}/data
mkdir -p ${WORK_DIR}/run
mkdir -p ${WORK_DIR}/scratch


## Prepare for the SOAPdenovo2-assembled sample contigs and scaffolds using TRegGA workflow.
# Note: here the contigs have been assembled previously, and we are just retrieving those contig files.
cd ${prereq_DIR}
for i in ${SAMPLE}
do
ln -s ${denovo_DIR}/${i}/${i}-soap.contig .
makeblastdb -in ${i}-soap.contig -dbtype nucl -out DB_${i}_contig -parse_seqids
done

# Retrieve and index the reference genome
echo "
#!/bin/bash
#PBS -m abe
#PBS -l nodes=1:ppn=8,vmem=20gb,walltime=01:00:00
#PBS -N prereq-on-${REFSEQNAME}
#PBS -j oe

module add bwa/0.7.6a
module add java
module add samtools/0.1.19
module add picard/1.52

cd ${prereq_DIR}
# Retrieve the reference sequence
sh ${bin_DIR}/xgetseq

" > prereq-on-${REFSEQNAME}.qsub
qsub prereq-on-${REFSEQNAME}.qsub


#!/bin/bash
source ./0SOURCE

## Prerequisite data:
# The soapdenovo2-assembled contigs of genomic samples.
# The reference sequence.

## Prerequisite software:
# NCBI BLAST+
# blat/35 (The BLAST-Like Alignment Tool)

##--------------------------------------------
# Setup sub-directory for workflow
cd ${WORK_DIR}
mkdir -p ${WORK_DIR}/prereq
mkdir -p ${WORK_DIR}/doc
mkdir -p ${WORK_DIR}/bin
mkdir -p ${WORK_DIR}/src
mkdir -p ${WORK_DIR}/data
mkdir -p ${WORK_DIR}/run
mkdir -p ${WORK_DIR}/scratch

## Prepare for the SOAPdenovo2-assembled sample contigs.
# Note: the contigs have been assembled previously using TRegGA workflow, and we are just linking those contig files here.
cd ${prereq_DIR}
for i in ${SAMPLE}
do
ln -s ${denovo_DIR}/${i}/${i}-SOAP/${i}-soap.contig .
makeblastdb -in ${i}-soap.contig -dbtype nucl -out DB_${i}_contig -parse_seqids
done

# Retrieve and index the reference genome
echo "
#!/bin/bash
#PBS -m abe
#PBS -l nodes=1:ppn=8,vmem=20gb,walltime=00:30:00
#PBS -N prereq-on-${REFSEQNAME}
#PBS -j oe

cd ${prereq_DIR}

# Retrieve and index the reference sequence for Blast
sh ${bin_DIR}/xgetseq
" > prereq-on-${REFSEQNAME}.qsub
qsub prereq-on-${REFSEQNAME}.qsub


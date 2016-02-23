# Finding whole genome long INDELs with denovo-assembled contigs from NGS reads
Contributed by Chun-Yuan Huang, 2/15/2016

## Aims:
This workflow is to to find whole genome (WG) long insertion and deletion (indels) of genomic samples as compared to reference genome using de-novo assembled contigs from NGS reads. It takes de-novo assembled contigs and reference genome sequence as inputs, then generates summary tables that describe the insertion/deletion positions and sizes, as well as the insertion/deletion sequences of the sample. BLAT (BLAST-like alignment tool) is used for the pairwise sequence alignment and indel finding. The results from this workflow are indels of longer sizes due to the use of contigs, as opposed to short indels often seen from raw-read based methods such as GATK. The long indels can be valuable for situations such as the mutagenesis sequence validation after TALEN/CRISPR/ZFN genome engineering, transposon jumping event investigation, or cultivar-specific molecular marker finding.

## Workflow description:
1. Blat of sample contigs (by SOAP-denovo assembly) against WG reference.
2. Generate filtered blat hits table for contigs that contain gaps whose total length larger than the defined size.
3. Calculate the Q_gapStarts, Q_gapSizes, T_gapStarts and T_gapSizes based on each gap using the block info from the Blat result, where Q is for Query (the samples) and T is for Target (the reference genome)
4. Generate indel tables for each insertion and deletion.
5. Make indel summary table that combines same indels from all samples in each row based on the indel features
6. Use the indel summary table to retrieve indel sequences.

## Workflow execution:
1. Edit and setup the parameters as described in 0SOURCE, then `source 0SOURCE`
2. Edit and prepare for the prerequisite files and softwares as described in PREREQ.sh, then `sh PREREQ.sh`
3. Generate and submit qsub script for whole genome blat alignment on Mason: `sh x1-WGblat`
4. Submit qsub script for whole genome indel analysis on Mason: `qsub x2-WGindel`
5. Find main outputs in *data/*.
6. Cleanup files with `sh xcleanup`

## Sub-directories for workflow implementation:
1. *prereq/*: prerequisite inputs such as retrieval and storage of TRegGA assembled contigs; retrieval and storage of reference genomes, preparation of BLAST+ database for reference genome.
2. *doc/*: reference and tutorial documents.
3. *bin/*: ancillary codes and scripts.
4. *src/*: prerequisite softwares
5. *run/*: main scripts and execution results.
6. *data/*: final outputs and reports.

## Notes: 
1. The workflow default to run a test case using 10% contigs from rice cultivar Zhengshan97 against reference rice Japponica Chr10. 
2. The run time for whole genome blat of a typical 3kRGP rice cultivar contigs against reference rice Japonica takes about 90-100 hrs on Mason, so plan carefully for submitting the job `x1-WGblat`.

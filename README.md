# MetaCRAST: reference-guided CRISPR detection in metagenomes
# Introduction
`MetaCRAST` is a tool to detect CRISPR arrays in raw, unassembled metagenomes. Unlike other tools, it uses expected CRISPR direct repeat (DR) sequences from assembled contigs or bacterial genomes to guide metagenomic CRISPR detection. It uses a fast implementation of the Wu-Manber multipattern search algorithm to rapidly select reads that contain an expected DR sequence. It then proceeds through these reads to find more copies of the DR within acceptable distances of each other (i.e., with acceptable length spacers between them). Spacers between these DRs are then extracted and compiled into a non-redundant set with CD-HIT. 

`MetaCRAST` is also parallelizable thanks to the application of Many Core Engine (MCE) and fasta-splitter.pl. Metagenome inputs can be split up for parallel CRISPR detection in multi-core systems (see use of -n option). 

# Installation

Dependencies: `fasta-splitter.pl`, `cd-hit`, `perl` (of course!)

CD-HIT can be installed by entering `sudo apt-get install cd-hit`. It can also be obtained here: https://github.com/weizhongli/cdhit.

fasta-splitter.pl is included in the repository. It can also be obtained here: http://kirill-kryukov.com/study/tools/fasta-splitter/.

Dependencies (CPAN): Text::Levenshtein::XS, String::Approx, Getopt::Std, Bio::SeqIO, Bio::Perl, MCE, and MCE::Loop

A simple local install script is included (`local_install.sh`).

# Usage 
`MetaCRAST` takes **FASTA** files as inputs (both for the CRISPR DRs and the metagenome). Optional arguments are in brackets. 

`MetaCRAST -p patterns.fasta -i infile.fasta -o output_dir [-t] tmp_dir -d dist_allowed [-h] use Hamming Distance [-r] reverse_complement [-l] max_spacer_length [-c] cd_hit_similarity_threshold [-a] total_spacer_cd_hit_similarity_threshold [-n] num_procs`

The required arguments are as follows:
* **`-p`** Pattern file containing query DR sequences in **FASTA** format
* **`-i`** Input metagenome in **FASTA** format
* **`-o`** Output directory for detected reads and spacers.
* **`-d`** Allowed edit distance (insertions, deletions, or substitutions) for initial DR detection with the Wu-Manber algorithm.

And the optional arguments are:
* **`-t`**
* **`-h`**
* **`-r`**
* **`-l`**
* **`-c`**
* **`-a`**
* **`-n`**

# Examples 

# Citation
If you use `MetaCRAST` in published work, please include a reference to my Bioinformatics paper.

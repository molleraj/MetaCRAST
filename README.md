# MetaCRAST: reference-guided CRISPR detection in metagenomes
# Introduction
`MetaCRAST` is a tool to detect CRISPR arrays in raw, unassembled metagenomes. Unlike other tools, it uses expected CRISPR direct repeat (DR) sequences from assembled contigs or bacterial genomes to guide metagenomic CRISPR detection. It uses a fast implementation of the Wu-Manber multipattern search algorithm to rapidly select reads that contain an expected DR sequence. It then proceeds through reads identified in the previous step to find DR sequences within acceptable distances of each other (i.e., with acceptable length spacers between them). Spacers between these DRs are then extracted and clustered into a non-redundant set with CD-HIT. 

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
* **`-o`** Output directory for detected reads and spacers
* **`-d`** Allowed edit distance (insertions, deletions, or substitutions) for initial read detection with the Wu-Manber algorithm and subsequent DR detection steps

And the optional arguments are:
* **`-t`** Temporary directory to put split metagenome (use this if -n option also selected)
* **`-h`** Use Hamming distance metric (substitutions only - no insertions or deletions) to find direct repeat locations in reads (default: use Levenshtein distance metric - look for sequences matching DR within insertion, deletion, and/or substitution edit distance) 
* **`-r`** Search for reverse complement of CRISPR direct repeat sequences
* **`-l`** Maximum spacer length in bp
* **`-c`** CD-HIT similarity threshold for clustering spacers detected for each query direct repeat
* **`-a`** CD-HIT similarity threshold for clustering all detected spacers 
* **`-n`** Number of processors to use for parallel processing

# Examples 

Sample query sequences are included. 

# Citation
If you use `MetaCRAST` in published work, please include a reference to my Bioinformatics paper.

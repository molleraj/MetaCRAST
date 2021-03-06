# MetaCRAST: reference-guided CRISPR detection in metagenomes
# Introduction
`MetaCRAST` (Metagenomic CRISPR Reference-Aided Search Tool) is a tool to detect CRISPR arrays in raw, unassembled metagenomes. Unlike other tools, it uses expected CRISPR direct repeat (DR) sequences from assembled contigs or bacterial genomes to guide metagenomic CRISPR detection. It uses a fast implementation of the Wu-Manber multipattern search algorithm to rapidly select reads that contain an expected DR sequence. It then proceeds through reads identified in the previous step to find DR sequences within acceptable distances of each other (i.e., with acceptable length spacers between them). Spacers between these DRs are then extracted and clustered into a non-redundant set with CD-HIT. 

`MetaCRAST` is also parallelizable thanks to the application of Many Core Engine (MCE) and fasta/q-splitter.pl. Metagenome inputs can be split up for parallel CRISPR detection in multi-core systems (see use of -n option). It uses the very fast seqtk-based subroutine `readfq` to load FASTA/Q files and MCE::Shared (`mce_open`) to share temporary files among threads.

# Installation

Dependencies: `fasta-splitter.pl`, `fastq-splitter.pl`, `cd-hit`, `perl` (of course!)

CD-HIT can be installed by entering `sudo apt-get install cd-hit`. It can also be obtained here: https://github.com/weizhongli/cdhit.

`fasta-splitter.pl` and `fastq-splitter.pl` are included in the repository. They can also be obtained here (http://kirill-kryukov.com/study/tools/fasta-splitter/) and here (http://kirill-kryukov.com/study/tools/fastq-splitter/), respectively.
`fasta-splitter.pl` and `fastq-splitter.pl` depend on File::Util, File::Path, File::Basename, and Getopt::Long. Make sure to install these using CPAN (these will be installed by default using `local_install.sh`).

Dependencies (CPAN): Text::Levenshtein::XS, String::Approx, Getopt::Std, Bio::SeqIO, Bio::Perl, MCE, MCE::Loop, and MCE::Shared

The `readfq` subroutine is included within the `MetaCRAST` script itself. For more details about `readfq`, go to its GitHub repository (https://github.com/lh3/readfq). 

A simple local install script is included (`local_install.sh`). To clone and install from this repository, follow these commands from your home directory:

`git clone https://github.com/molleraj/MetaCRAST.git`

`cd ~/MetaCRAST`

`sh local_install.sh`

A sample simulated metagenome is included in `MetaCRAST/data` (`simAMDmetagenome-600-454.fasta`). This is a simulated acid mine drainage metagenome generated with Grinder (Angly et al., 2012). You can use this to test the software, as follows, from the MetaCRAST directory (`MetaCRAST/`):

`MetaCRAST -p query/AMDquery.fa -i data/simAMDmetagenome-600-454.fasta -o test -d 3 -l 60 -c 0.9 -a 0.9`

Then, to check the number of spacers detected, do this:

`grep -c ">" test/totalSpacersCD90.fa`

There should be 117 spacers detected.

I have also included two other alternate versions of `MetaCRAST` that may provide better performance. `MetaCRASTs` is not parallelizable, but uses the fast `open` and `readfq` routines to open FASTA/Q files, while `MetaCRASTbp` relies on BioPerl to load FASTA/Q files but does not rely on `mce_open` (MCE::Shared) to share temporary FASTA/Q file parts. 

Recent evaluations suggest mce_open slows down the script considerably, and the open/readfq-dependent `MetaCRASTs` provides the best performance across many average read lengths and sequencing error models (see our recently published PeerJ article). 

As of January 2018, I have added a third version of MetaCRAST (`MetaCRASTp`) edited by MCE developer Mario E. Roy. This version has numerous improvements to MCE parallelization, which improve speed almost ten-fold relative to the non-parallel version `MetaCRASTs` (tests performed on 600 bp average, 100,000 read simulated 454 metagenome). These improvements include the following:

Updated to use many cores efficiently during patternloop.
1. Provided fast read iterator with support for Fasta and fastq formats.
2. Removed overhead regarding original MCE parallelization.
3. Enabled chunking capability for patternloop (via fasta_iter).
4. Enabled parallelization for spacerloop.
5. Apply CPU affinity on Linux platforms (2+ CPU sockets).

-- Mario Roy

CPU affinity can be applied using the `-z` option for systems running on 2 or more nodes (sockets). An example is below.
`MetaCRASTp -p query/AMDquery.fa -i data/simAMDmetagenome-600-454.fasta -o test -d 3 -l 60 -c 0.9 -a 0.9 -n 64 -z`

# Usage 
`MetaCRAST` takes **FASTA or FASTQ** files as inputs (both for the CRISPR DRs and the metagenome). Optional arguments are in brackets. 

`MetaCRAST -p patterns.fasta -i infile.fasta -o output_dir [-t] tmp_dir -d dist_allowed [-h] use Hamming Distance [-r] reverse_complement [-l] max_spacer_length [-c] cd_hit_similarity_threshold [-a] total_spacer_cd_hit_similarity_threshold [-n] num_procs`

The required arguments are as follows:
* **`-p`** Pattern file containing query DR sequences in **FASTA or FASTQ** format
* **`-i`** Input metagenome in **FASTA or FASTQ** format
* **`-o`** Output directory for detected reads and spacers
* **`-d`** Allowed edit distance (insertions, deletions, or substitutions) for initial read detection with the Wu-Manber algorithm and subsequent DR detection steps

And the optional arguments are:
* **`-t`** Temporary directory to put metagenome parts (use this if -n option also selected)
* **`-q`** Input metagenome is a FASTQ file (directs use of `fastq-splitter.pl` instead of `fasta-splitter.pl`)
* **`-h`** Use Hamming distance metric (substitutions only - no insertions or deletions) to find direct repeat locations in reads (default: use Levenshtein distance metric - look for sequences matching DR within insertion, deletion, and/or substitution edit distance) 
* **`-r`** Search for reverse complements of CRISPR direct repeat sequences (and return the reverse complements of spacers in reads containing the reverse complements of query direct repeats)
* **`-l`** Maximum spacer length in bp
* **`-c`** CD-HIT similarity threshold for clustering spacers detected for each query direct repeat (value from 0 to 1)
* **`-a`** CD-HIT similarity threshold for clustering all detected spacers (value from 0 to 1)
* **`-n`** Number of processors to use for parallel processing (and number of temporary metagenome parts)

To get queries, there is another script provided (`getDRquery.pl`) along with a database of direct repeats downloaded from CRISPRdb and indexed taxonomically (`DRdatabaseTax.fa`).  

Here is the usage of `getDRquery.pl`: `getDRquery.pl DR_database_path query output_file`

* **`DR_database_path`** Path to the direct repeat sequence database in FASTA format (e.g., `~/MetaCRAST/data/DRdatabaseTax.fa`)
A new version of the DR database is provided as of July 17, 2017. This version contains some 3,253 parsed DRs from the most recent DR database provided by CRISPRdb, compared with the 1,978 parsed DRs from the last CRISPRdb update (2014). The new version is called `DRdatabaseTax-new.fa`.  
* **`query`** The taxon you want to look up in the database (e.g., Escherichia). This should be a kingdom, phylum, class, order, family, genus, or species name.
* **`output_file`** Name of your output query DR file in FASTA format (e.g., `sample_query.fa`)

# Output

The input sequences for MetaCRAST both include a file of metagenomic reads (`-i infile.fasta`) and a file of query direct repeat sequences (`-p patterns.fasta`). The default output includes a set of FASTA files containing reads that match each pattern (named `Pattern-0-<DR sequence>.fa` to `Pattern-n-<DR sequence>.fa`, where `<DR sequence>` is the direct repeat nucleotide sequence) and a set of FASTA files containing spacers extracted from these reads (named `Spacer-0-<DR sequence>.fa` to `Spacer-n-<DR sequence>.fa`). All spacers collected amongst all search patterns are also saved as a FASTA file called `totalSpacers.fa`.

Each sequence in the read FASTA files (`Pattern-n-<DR sequence>.fa`) has the same sequence ID description as the read identified in the original metagenome FASTA file. Each spacer sequence in the spacer FASTA file is labeled by the number of the sequence in the original query file, the number of the spacer among those detected, and the number of times the spacer sequence was detected (e.g., P0S0C1 for the first spacer among those detected for the first pattern, found once in the search). Thanks to Cecilia Furugard for the suggestion.

If options `-c` or `-a` are selected, spacers detected for each pattern (`-c`) or for all patterns (`-a`) will be clustered at the specified similarity threshold (e.g., 0.9). When `-c` is used, a set of clustered spacer FASTA files will be generated (e.g., `CD<similarity threshold>Spacer-0-<DR sequence>.fa`, where `<similarity threshold>` is the percent similarity threshold specified).  If `-a` is specified, another file (CD<similarity threshold>finalSpacers.fa) is created which contains all detected spacers clustered at the given similarity threshold. 

# Examples 

Sample query sequences are included in `MetaCRAST/query`. These queries contain DR sequences from CRISPR arrays known to be found in genomes of majority components of acid mine drainage (AMD) and enhanced biological phosphorus removal (EBPR) environments. 

Here is how you can use the included simulated metagenome to test MetaCRAST: 

`MetaCRAST -p query/AMDquery.fa -i data/simAMDmetagenome-600-454.fasta -o test -d 3 -l 60 -c 0.9 -a 0.9` 

See installation notes for more details about this test. 

# Issues

If you notice any bugs or issues, please report them under the 'Issues' tab or contact me at abraham.moller@emory.edu or molleraj@gmail.com.

# Citation
If you use `MetaCRAST` in published work, please include a reference to my PeerJ article: Moller AG, Liang C. (2017) MetaCRAST: reference-guided extraction of CRISPR spacers from unassembled metagenomes. PeerJ 5:e3788 https://doi.org/10.7717/peerj.3788. 

Previously, `MetaCRAST` was described in a PeerJ Preprint: Moller AG, Liang C. (2016) MetaCRAST: Reference-guided extraction of CRISPR spacers from unassembled metagenomes. PeerJ Preprints 4:e2278v2 https://doi.org/10.7287/peerj.preprints.2278v2. The article was accepted for publication in PeerJ on August 19, 2017. 

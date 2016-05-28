# MetaCRAST
MetaCRAST: reference-guided CRISPR detection in metagenomes

Dependencies: fasta-splitter.pl, cd-hit

Dependencies (CPAN): Text::Levenshtein::XS, String::Approx, Getopt::Std, Bio::SeqIO, Bio::Perl, MCE, and MCE::Loop

Usage: MetaCRAST -p patterns.fasta -i infile.fasta -o output_dir [-t] tmp_dir -d dist_allowed [-h] (use Hamming Distance) [-r] reverse_complement [-l] max_spacer_length [-c] cd_hit_similarity_threshold [-a] total_spacer_cd_hit_similarity_threshold [-n] num_procs

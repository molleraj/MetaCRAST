#!/bin/sh

# install cd-hit
sudo apt-get install cd-hit

# install CPAN packages 
sudo perl -MCPAN -e install Text::Levenshtein::XS String::Approx Getopt::Std Bio::SeqIO Bio::Perl MCE MCE::Loop

# make bin files executable
chmod 777 ./bin/*

# add MetaCRAST and MetaCRAST/bin to PATH

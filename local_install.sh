# How to install
# IN HOME FOLDER: git clone https://github.com/molleraj/MetaCRAST.git
# chmod 777 ~/MetaCRAST/local_install.sh

#!/bin/sh

# install cd-hit
sudo apt-get install cd-hit

# install CPAN packages 
sudo perl -MCPAN -e install Text::Levenshtein::XS String::Approx Getopt::Std Bio::SeqIO Bio::Perl MCE MCE::Loop

# make bin files executable
chmod 777 ~/MetaCRAST/bin/*

# add MetaCRAST and MetaCRAST/bin to PATH
export PATH="$HOME/MetaCRAST:/MetaCRAST/bin:$PATH"
echo "export PATH='$HOME/MetaCRAST:$HOME/MetaCRAST/bin:$PATH'" >> ~/.bash_profile
echo "export PATH='$HOME/MetaCRAST:$HOME/MetaCRAST/bin:$PATH'" >> ~/.profile
source ~/.bash_profile
source ~/.profile

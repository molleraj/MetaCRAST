#!/usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;
use Bio::DB::GenBank;
#use Bio::LITE::Taxonomy::NCBI;
#use Bio::LITE::Taxonomy::NCBI::Gi2taxid;

# grab exhaustive DR list from CRISPRdb
# need browser user agent (wget -U) to get list

my $home = `echo "\$HOME"`;
chop $home;

print `wget -U 'Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0' http://crispr.u-psud.fr/crispr/BLAST/DR/DRdatabase`;
print `mv DRdatabase DRdatabase.fa`;
#print `cp DRdatabase.fa DRdatabaseTax.fa`;

#my $dict = Bio::LITE::Taxonomy::NCBI::Gi2taxid->new(dict=>$home."/taxonomy/gi_taxid_nucl.bin");

#my $taxDB2 = Bio::LITE::Taxonomy::NCBI->new(
#                                               db=>"NCBI",
#											   names=>$home."/taxonomy/names.dmp",
#											   nodes=>$home."/taxonomy/nodes.dmp",
#                                               dict=>$home."/taxonomy/gi_taxid_nucl.bin"
#                                            );

my $input_DBfile = "DRdatabase.fa";
my $output_DBfile = "DRdatabaseTax.fa";

my $DBfile_IN = Bio::SeqIO->new(-file => $input_DBfile, '-format' => 'Fasta');
my $DBfile_OUT = Bio::SeqIO->new(-file => ">$output_DBfile", '-format' => 'Fasta');
$DBfile_OUT->preferred_id_type('display');

while (my $DBfile_IN_object = $DBfile_IN->next_seq()) {
	my $currentDBseq = $DBfile_IN_object->seq();
	my $currentDBid = $DBfile_IN_object->display_id();
	#print $currentDBid."\n";
	#print $currentDBseq."\n";

	my @code = split(/\|/,$currentDBid);
	my %short_code = ();

	foreach my $code_id (@code) {
		#print $code_id."\n";
		my @code_id_parts = split(/\_/,$code_id);
		my $short_code_id = $code_id_parts[0]."_".$code_id_parts[1];
		$short_code{$short_code_id} = $code_id;
		#print $short_code_id."\n";
	}

	my @unique_code = keys %short_code;
	
	foreach my $grab_unique_code_id (@unique_code) {
		my $gb = Bio::DB::GenBank->new();
		my $seq_object = $gb->get_Seq_by_id($grab_unique_code_id);
		my $species_object = $seq_object->species;
		my $species_string = $species_object->node_name;
		my @classification = $seq_object->species->classification;
		@classification = reverse @classification;
		my $newDRHeader = join('_',@classification);
		$newDRHeader =~ s/\s/_/g;
		print $newDRHeader."\n";
		$DBfile_IN_object->display_id($newDRHeader);
		$DBfile_OUT->write_seq($DBfile_IN_object); 
	}
}




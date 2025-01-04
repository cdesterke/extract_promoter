#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# Variables for command-line arguments
my $gtf_file;
my $gene_list_file;
my $output_bed_file = "promoters.bed";  # Default output file
my $upstream = 1000;  # Default upstream region
my $downstream = 100;  # Default downstream region

# Display usage message if no arguments are provided or if there's an error
sub usage {
    print <<"USAGE";
Usage: $0 --gtf <GTF file> --genes <gene list file> [--output <output BED file>] [--upstream <bp>] [--downstream <bp>]

Required arguments:
  --gtf       Path to the input GTF file containing gene annotations.
  --genes     Path to the input file containing the list of genes (one gene per line).

Optional arguments:
  --output    Name of the output BED file (default: promoters.bed).
  --upstream  Number of base pairs upstream of the TSS for the promoter region (default: 1000 bp).
  --downstream Number of base pairs downstream of the TSS for the promoter region (default: 100 bp).

Example:
  $0 --gtf annotations.gtf --genes gene_list.txt --output promoters.bed --upstream 1500 --downstream 200
USAGE
    exit;
}

# Parse command-line arguments
GetOptions(
    'gtf=s' => \$gtf_file,
    'genes=s' => \$gene_list_file,
    'output=s' => \$output_bed_file,
    'upstream=i' => \$upstream,
    'downstream=i' => \$downstream,
) or usage();

# Validate required parameters
usage() unless $gtf_file && $gene_list_file;

# Load the gene list into a hash
open(my $genes_in, "<", $gene_list_file) or die "Unable to open $gene_list_file: $!";
my %genes = map { chomp; $_ => 1 } <$genes_in>;
close($genes_in);

# Open the GTF and output files
open(my $gtf_in, "<", $gtf_file) or die "Unable to open $gtf_file: $!";
open(my $bed_out, ">", $output_bed_file) or die "Unable to open $output_bed_file: $!";

# Process the GTF file
while (<$gtf_in>) {
    chomp;
    next if /^#/;  # Skip comment lines

    my @fields = split("\t", $_);
    next unless $fields[2] eq "gene";  # Focus only on gene annotations

    # Extract information from the GTF
    my ($chr, $start, $end, $strand, $attributes) = @fields[0, 3, 4, 6, 8];
    my ($gene_id) = $attributes =~ /gene_name "([^"]+)"/;  # Extract gene name (adjust if necessary)

    # Skip if the gene is not in the list
    next unless exists $genes{$gene_id};

    # Calculate the promoter region based on strand
    my ($promoter_start, $promoter_end);
    if ($strand eq "+") {
        $promoter_start = $start - $upstream;
        $promoter_end = $start + $downstream;
    } else {
        $promoter_start = $end - $downstream;
        $promoter_end = $end + $upstream;
    }

    # Ensure that the start position is not negative
    $promoter_start = 0 if $promoter_start < 0;

    # Write the promoter region to the output BED file
    print $bed_out join("\t", $chr, $promoter_start, $promoter_end, $gene_id, ".", $strand), "\n";
}

close($gtf_in);
close($bed_out);

print "BED file generated: $output_bed_file\n";

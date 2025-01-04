#!/bin/bash

# URL of the page containing Gencode files for Homo sapiens
GENCODE_URL="https://www.gencodegenes.org/human/"
OUTPUT_DIR="human"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to display script usage
usage() {
    echo "Usage : $0"
    echo "\nThis script downloads the latest GTF file from Gencode for Homo sapiens, decompresses it, and installs it into a 'human' directory."
    echo "\nNo options are required. Simply run it as follows:"
    echo "  ./$(basename "$0")"
    echo "\nEnsure that 'curl' and 'gunzip' are installed on your system."
    exit 1
}

# Function to get the latest GTF file URL
get_latest_gtf_url() {
    local html=$(curl -s "$GENCODE_URL")

    # Find the compressed GTF file link
    local gtf_url=$(echo "$html" | grep -oP 'href="[^"]+primary_assembly[^"]+\.gtf\.gz"' | head -n 1 | cut -d '"' -f 2)

    if [[ $gtf_url =~ ^http ]]; then
        echo "$gtf_url"
    else
        echo "$GENCODE_URL$gtf_url"
    fi
}

# Function to download a file
download_file() {
    local url=$1
    local destination=$2
    echo "Downloading $url to $destination..."
    curl -L "$url" -o "$destination"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to download $url."
        exit 1
    fi
}

# Function to decompress a GZ file
decompress_gz() {
    local file_path=$1
    local output_path=$2
    echo "Decompressing $file_path to $output_path..."
    gunzip -c "$file_path" > "$output_path"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to decompress $file_path."
        exit 1
    fi
}

# Main function
main() {
    echo "Gencode GTF File Download Script"

    # Get the latest GTF file URL
    local gtf_url=$(get_latest_gtf_url)
    if [[ -z $gtf_url ]]; then
        echo "Error: Could not find the URL for the latest GTF file."
        exit 1
    fi
    echo "Latest GTF file found: $gtf_url"

    # Temporary and final file names
    local gtf_gz_file="$OUTPUT_DIR/latest_gencode.gtf.gz"
    local gtf_file="$OUTPUT_DIR/latest_gencode.gtf"

    # Download the compressed GTF file
    download_file "$gtf_url" "$gtf_gz_file"

    # Decompress the GTF file
    decompress_gz "$gtf_gz_file" "$gtf_file"

    # Remove the compressed file
    rm "$gtf_gz_file"

    echo "GTF file is available at: $gtf_file"
}

# Display usage if user asks for help
if [[ $1 == "--help" || $1 == "-h" ]]; then
    usage
fi

main

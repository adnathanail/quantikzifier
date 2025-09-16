#!/bin/bash
# Usage: ./quantikzify.sh inputfile.tex

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 inputfile.tex"
  exit 1
fi

INPUTFILE="$1"
BASENAME="$(basename "$INPUTFILE" .tex)"

# Copy input to standard name
cp "data/$INPUTFILE" "quantikz_input.tex"

ls

# Run pdflatex to generate PDF
pdflatex "template.tex"

# # Remove auxiliary files
# rm quantikz_input.tex template.aux template.log

# Convert PDF to PNG
convert -density 300 "template.pdf" -quality 100 "template.png"

# # Remove intermediate files
# rm template.pdf

# Rename PNG to match input file base name,
#   and put it back in the data directory (volume mount)
mv "template.png" "data/${BASENAME}.png"
#!/bin/bash
# Usage: ./entrypoint.sh inputfile.tex

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 inputfile.tex"
  exit 1
fi

INPUTFILE="$1"
BASENAME="$(basename "$INPUTFILE" .tex)"

# Copy input to standard name
cp "data/$INPUTFILE" "quantikz_input.tex"

# Run pdflatex to generate PDF
pdflatex "template.tex"

# Convert PDF to PNG
convert -density 300 "template.pdf" -quality 100 "template.png"

# Rename PNG to match input file base name,
#   and put it back in the data directory (volume mount)
mv "template.png" "data/${BASENAME}.png"
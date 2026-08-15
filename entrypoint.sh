#!/bin/bash
# Usage: ./entrypoint.sh inputfile.tex   (quantikz)
#        ./entrypoint.sh inputfile.tikz  (TikZiT)

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 inputfile.tex|inputfile.tikz"
  exit 1
fi

INPUTFILE="$1"
DATADIR="data"

if [ ! -f "$DATADIR/$INPUTFILE" ]; then
  echo "Error: '$INPUTFILE' not found in the mounted data directory"
  exit 1
fi

EXTENSION="${INPUTFILE##*.}"
BASENAME="$(basename "$INPUTFILE" ".$EXTENSION")"

# Let LaTeX find files sitting next to the input (e.g. TikZiT style files).
# The trailing colon keeps the default search path, which includes /work
export TEXINPUTS="/work/$DATADIR:$TEXINPUTS:"

case "$EXTENSION" in
  tex)
    echo "Treating '$INPUTFILE' as a quantikz diagram"
    TEMPLATE="template-quantikz.tex"
    ;;
  tikz)
    echo "Treating '$INPUTFILE' as a TikZiT diagram"
    TEMPLATE="template-tikzit.tex"

    # Pull in the user's own style files if they shipped any alongside the
    #   diagram, otherwise fall back to the bundled ZX ones.
    # .tikzdefs must come first, as .tikzstyles depends on it (e.g. for colours)
    : > "qzfr_styles.tex"
    for STYLEFILE in "$DATADIR"/*.tikzdefs "$DATADIR"/*.tikzstyles; do
      [ -f "$STYLEFILE" ] || continue
      echo "Using style file $(basename "$STYLEFILE")"
      printf '\\input{%s}\n' "$(basename "$STYLEFILE")" >> "qzfr_styles.tex"
    done
    if [ ! -s "qzfr_styles.tex" ]; then
      echo "No .tikzdefs/.tikzstyles found alongside '$INPUTFILE', using bundled ZX styles"
      printf '\\input{circuits.tikzdefs}\n\\input{circuits.tikzstyles}\n' > "qzfr_styles.tex"
    fi
    ;;
  *)
    echo "Error: unsupported file type '.$EXTENSION' (expected .tex or .tikz)"
    exit 1
    ;;
esac

# Copy input to standard name
cp "$DATADIR/$INPUTFILE" "qzfr_input.tex"

# Run pdflatex to generate PDF
pdflatex -interaction=nonstopmode -halt-on-error -jobname=qzfr_output "$TEMPLATE"

# Convert PDF to PNG
convert -density 300 "qzfr_output.pdf" -quality 100 "qzfr_output.png"

# Rename PNG to match input file base name,
#   and put it back in the data directory (volume mount)
mv "qzfr_output.png" "$DATADIR/${BASENAME}.png"

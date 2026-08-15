# Start from bare "medium" Tex Live image
FROM texlive/texlive:latest-medium

# Install latex packages
RUN tlmgr install \
# Standalone document class
    standalone \
# Necessary basic packages
    xargs \
    environ \
# Necessary tikz packages
    tikz-cd \
    quantikz \
# Necessary math packages
    braket \
# Packages needed by TikZiT style/definition files
    keycommand \
    graphbox \
    titlesec

# Install ImageMagick for PDF to PNG conversion
RUN apt-get update \
    && apt-get install -y imagemagick \
    && apt-get clean

WORKDIR /work

# Copy the script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy the LaTeX templates
COPY template-quantikz.tex /work/template-quantikz.tex
COPY template-tikzit.tex /work/template-tikzit.tex

# Copy the TikZiT package, plus the default ZX style/definition files
#   (used when the input folder doesn't provide its own)
COPY tikzit/ /work/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Usage instructions
# To build the Docker image, run:
# docker build -t qzfr .
# To compile a quantikz document, run:
# docker run --rm -v PATH_TO_YOUR_TEX_FILES:/work/data qzfr YOUR_FILE.tex
# To compile a TikZiT document, run:
# docker run --rm -v PATH_TO_YOUR_TIKZ_FILES:/work/data qzfr YOUR_FILE.tikz

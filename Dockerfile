# Start from bare "medium" Tex Live image
FROM texlive/texlive:latest-medium

# Install standalone document class
RUN tlmgr install standalone \
# Install necessary basic packages
    && tlmgr install xargs \
    && tlmgr install environ \
# Install necessary tikz packages
    && tlmgr install tikz-cd \
    && tlmgr install quantikz \
# Install necessary math packages
    && tlmgr install braket

# Install ImageMagick for PDF to PNG conversion
RUN apt-get update \
    && apt-get install -y imagemagick \
    && apt-get clean

WORKDIR /work

# Copy the script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/quentrypointantikzify.sh

# Copy the LaTeX template
COPY template.tex /work/template.tex

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Usage instructions
# To build the Docker image, run:
# docker build -t qzfr .
# To compile a LaTeX document, run:
# docker run --rm -v PATH_TO_YOUR_TEX_FILES:/work/data qzfr YOUR_FILE.tex

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

WORKDIR /data

# Default command: compile main.tex to main.pdf
ENV LATEX_FILE=main.tex
CMD ["pdflatex", "${LATEX_FILE}"]

# Usage instructions
# To build the Docker image, run:
# docker build -t latexer .
# To compile a LaTeX document, run:
# docker run --rm -v $(pwd):/data latexer
# This will compile main.tex in the current directory and output main.pdf
# You can change main.tex to any other .tex file by modifying the CMD in the Dockerfile or by overriding it in the docker run command.
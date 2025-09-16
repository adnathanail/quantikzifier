# quantikzifier
Docker image to quickly compile quantikz code into images

This is solving a problem that maybe only I have, and it may be solely to do with my broken local LaTex setup

I'm using [Texifier](https://www.texifier.com/) which has a lovely live-reloading functionality.
Sadly I can't seem to get this to work with the [quantikz](https://mirrors.ibiblio.org/CTAN/graphics/pgf/contrib/quantikz/quantikz.pdf) package for generating diagrams of quantum circuits.

So I've built a janky Docker setup which takes a tex file containing just a `\begin{quantikz} blah \end{quantikz}` block, substitutes it into a basic LaTex document, and produces a PNG of htat circuit!

## Local usage
```shell
docker build -t qzfr .
docker run --rm -v $(pwd):/data -e LATEX_FILE=test1.tex qzfr
```

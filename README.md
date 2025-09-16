# qzfr (quantikzifier)
Docker image to quickly compile quantikz code into images

This is solving a problem that maybe only I have, and it may be solely to do with my broken local LaTex setup

I'm using [Texifier](https://www.texifier.com/) which has a lovely live-reloading functionality.
Sadly I can't seem to get this to work with the [quantikz](https://mirrors.ibiblio.org/CTAN/graphics/pgf/contrib/quantikz/quantikz.pdf) package for generating diagrams of quantum circuits.

So I've built a janky Docker setup which takes a tex file containing just a `\begin{quantikz} blah \end{quantikz}` block, substitutes it into a basic LaTex document, and produces a PNG of htat circuit!

## Docker Hub usage

I have shared this on Docker Hub for easy local usage

To compile the `test1.tex` file in this repo run:
```shell
docker run --rm -v ./test:/work/data adnathanail/qzfr test1.tex
```

To run this on any local file, replace `./test` with the path to the _folder_ containing your tex file(s), and replace `test1.tex` with the name of the tex file you would like to process

## Local usage
```shell
docker build -t qzfr .
docker run --rm -v $(pwd):/data -e LATEX_FILE=test1.tex qzfr
```

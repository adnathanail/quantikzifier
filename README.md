# quantikzifier
Docker image to quickly compile quantikz code into images

Build
```shell
docker build -t qzfr .
docker run --rm -v $(pwd):/data -e LATEX_FILE=test1.tex qzfr
```
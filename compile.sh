#!/usr/bin/env bash
pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf -output-directory=./ main.tex
makeglossaries main
bibtex main
pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf -output-directory=./ main.tex
pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf -output-directory=./ main.tex
pdflatex -file-line-error -interaction=nonstopmode -synctex=1 -output-format=pdf -output-directory=./ main.tex
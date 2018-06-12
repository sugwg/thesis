#!/bin/bash

pdflatex my_thesis.tex
pdflatex my_thesis.tex
bibtex thesis
pdflatex thesis.tex
cp thesis.pdf ~tjmassin/public_html/pdf/.

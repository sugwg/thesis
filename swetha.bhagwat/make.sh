#!/bin/bash

pdflatex thesis.tex
pdflatex thesis.tex
bibtex thesis
pdflatex thesis.tex
cp thesis.pdf ~tjmassin/public_html/pdf/.

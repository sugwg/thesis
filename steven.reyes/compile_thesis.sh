#!/bin/bash

pdflatex my_thesis.tex
pdflatex my_thesis.tex
bibtex my_thesis
pdflatex my_thesis.tex
cp my_thesis.pdf /home/steven.reyes/secure_html/thesis_dir/thesis.pdf

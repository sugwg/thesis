TEXFILES= acknowledge.tex \
introduction.tex \
s6-cbc-lowmass.tex \
far.tex \
ligo_south_study.tex \
s6_results.tex \
future_developments.tex \
pipeline_principles.tex \
theory.tex \
ihope_pipeline.tex \
s5_results.tex \
thesis.tex

BIBFILES=references.bib

STYFILES=bibunits.sty syrthesis.sty

BSTFILES=

BBLFILES=

default: thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES) $(STYFILES) $(BSTFILES)
	pdflatex thesis && bibtex thesis && bibtex thesis && pdflatex thesis && pdflatex thesis

clean:
	rm -f thesis.pdf *.aux *.bbl *.blg *.log *.lot *.toc *.lof *.bak *.tgz *.out

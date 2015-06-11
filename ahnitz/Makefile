TEXFILES= introduction.tex thesis.tex preface.tex

PNGFILES=
BIBFILES=references.bib

STYFILES=bibunits.sty syrthesis.sty

BSTFILES=

BBLFILES=

default: clean thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES) $(STYFILES) $(BSTFILES)
	pdflatex thesis && bibtex thesis && bibtex thesis && pdflatex thesis && pdflatex thesis

gr-qc: thesis.tgz

thesis.tgz: thesis.pdf
	tar -zcvf grqc.tgz $(TEXFILES) $(PNGFILES) $(BBLFILES) $(STYFILES)

clean:
	rm -f thesis.pdf *.aux *.bbl *.blg *.log *.lot *.toc *.lof *.bak *.tgz *.out *~

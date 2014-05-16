TEXFILES= thesis.tex \
acknowledge.tex \
introduction.tex \
lintrap.tex \
OT_paper.tex \
digsys.tex \
optical_spring.tex


PNGFILES=figures/block_mimo_paper.pdf \
figures/blocks_paper.pdf \
figures/cavity_paper.pdf \
figures/DC_offset_paper3.pdf \
figures/open_loops_TF_paper2.pdf \
figures/trap_drawing_paper2.pdf \
figures/trap_radPresA_paper2.pdf

BIBFILES=references.bib \
OT_paper.bib

STYFILES=bibunits.sty syrthesis.sty

BSTFILES=

BBLFILES=

default: thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES) $(STYFILES) $(BSTFILES)
	pdflatex thesis && bibtex thesis && bibtex thesis && pdflatex thesis && pdflatex thesis

gr-qc: thesis.tgz

thesis.tgz: thesis.pdf
	tar -zcvf grqc.tgz $(TEXFILES) $(PNGFILES) $(BBLFILES) $(STYFILES)

clean:
	rm -f thesis.pdf *.aux *.bbl *.blg *.log *.lot *.toc *.lof *.bak *.tgz *.out

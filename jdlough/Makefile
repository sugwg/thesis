TEXFILES= thesis.tex \
acknowledge.tex \
introduction.tex \
lintrap.tex \
digsys.tex \
noises.tex \
psl.tex \
optical_spring.tex \
results.tex \
conclusions.tex \
ottheory.tex \
otstab.tex \
otcon.tex \
otanginst.tex \
otradnoise.tex \
otderive.tex \
fluff.tex \
usefulformulas.tex


PNGFILES=figures/block_mimo_paper.pdf \
figures/blocks_paper.pdf \
figures/cavity_paper.pdf \
figures/DC_offset_paper3.pdf \
figures/open_loops_TF_paper2.pdf \
figures/trap_drawing_paper2.pdf \
figures/trap_radPresA_paper2.pdf

BIBFILES=references.bib \
OT_paper.bib \
papers.bib

STYFILES=bibunits.sty syrthesis.sty

BSTFILES=

BBLFILES=

TIKZFILES=tikz/roomlayout.tikz \
	  tikz/tnoisecone.tikz

TIKZPDFS=tikz/roomlayout.pdf \
	  tikz/tnoisecone.pdf

all: thesis.pdf

thesis.pdf: python/ $(TEXFILES) $(BIBFILES) $(STYFILES) $(BSTFILES) $(TIKZFILES)
	$(MAKE) -C python all && \
	latexmk -pdf -pdflatex="pdflatex --shell-escape %O %S" thesis.tex && \
	cp thesis.pdf ~/Dropbox/JimsThesis/

thesisvita.pdf: thesisvita.tex papersfull.bib vita.bst
	latexmk -pdf -pdflatex="pdflatex --shell-escape %O %S" thesisvita.tex


gr-qc: thesis.tgz

thesis.tgz: thesis.pdf
	tar -zcvf grqc.tgz $(TEXFILES) $(PNGFILES) $(BBLFILES) $(STYFILES)

tikz/%.pdf: tikz/%.tikz
	echo tikz/%.pdf 

redo-%:
	echo "tikz/%.pdf" 

clean:
	rm -f thesis.pdf *.auxlock *.fdb_latexmk *.fls *.aux *.bbl *.blg *.log *.lot *.toc *.lof *.bak *.tgz *.out *.tdo && \
	$(MAKE) -C tikz clean

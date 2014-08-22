TEX_FILES:=$(shell ls *.tex)
DRAFT_TITLE=paper
BIB_FILES=paper
PNG_FILES:=$(shell ls *.png)
TEX_V2:=paperv2
BIB_V2:=paperv2

all: pdf v2

v: $(TEX_FILES) $(BIB_FILES).bib $(PNG_FILES) $(DRAFT_TITLE).*
	echo $(TEX_FILES) $(BIB_FILES).bib $(DRAFT_TITLE) $(DRAFT_TITLE).*
	pdflatex $(TEX_V2).tex
	bibtex $(BIB_V2)
	pdflatex $(TEX_V2).tex
	pdflatex $(TEX_V2).tex

v2: $(TEX_FILES) $(BIB_FILES).bib $(PNG_FILES) $(DRAFT_TITLE).*
	echo $(TEX_FILES) $(BIB_FILES).bib $(DRAFT_TITLE) $(DRAFT_TITLE).*
	pdflatex -draftmode $(TEX_V2).tex
	bibtex $(BIB_V2)
	pdflatex -draftmode $(TEX_V2).tex
	pdflatex $(TEX_V2).tex

brute: $(TEX_FILES) $(PNG_FILES) $(BIB_FILES).bib
	sh makepdf

pdf: $(TEX_FILES) $(BIB_FILES).bib $(PNG_FILES) $(DRAFT_TITLE).*
	echo $(TEX_FILES) $(BIB_FILES).bib $(DRAFT_TITLE) $(DRAFT_TITLE).*
	pdflatex -draftmode $(DRAFT_TITLE).tex
	bibtex $(BIB_FILES)
	pdflatex -draftmode $(DRAFT_TITLE).tex
	pdflatex $(DRAFT_TITLE).tex

#pdf: dvipdf

dvi: $(TEX_FILES) $(BIB_FILES).bib
	latex $(DRAFT_TITLE).tex
	bibtex $(BIB_FILES)
	latex $(DRAFT_TITLE).tex
	latex $(DRAFT_TITLE).tex

dvipdf: dvi
	dvipdf $(DRAFT_TITLE).pdf

ps : dvi
	dvips -o $(DRAFT_TITLE).ps $(DRAFT_TITLE).dvi

# The || : is there to make sure that subsequent lines get executed even if
# some of the removes fail because the files to be removed do not exist.
clean:
	rm *.aux || :
	rm *.dvi || :
	rm *.log || :
	rm *.bbl || :
	rm *.blg || :
	rm $(DRAFT_TITLE).pdf || :

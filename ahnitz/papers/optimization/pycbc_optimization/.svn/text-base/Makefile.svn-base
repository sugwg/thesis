TEX = pdflatex
BIBTEX = bibtex
RM = rm

BIBFILES = ../../../bibtex/cbc-group.bib
IMGFILES = 
SRCNAME = pycbc_optimization

all: pycbc_optimization.pdf

pycbc_optimization.pdf: $(SRCNAME).tex $(IMGFILES) $(BIBFILES)
	$(TEX) $(SRCNAME)
	$(BIBTEX) $(SRCNAME)
	$(TEX) $(SRCNAME)
	$(TEX) $(SRCNAME)

clean:
	$(RM) -f $(SRCNAME).pdf $(SRCNAME).aux $(SRCNAME).log $(SRCNAME).out

veryclean: clean
	$(RM) $(SRCNAME).blg $(SRCNAME).bbl

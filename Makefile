default: thesis.pdf

thesis.pdf: acknowledge.tex \
            conclusion.tex \
            findchirp.tex \
            inspiral.tex \
            introduction.tex \
            macho.tex \
            papers.bib \
            pipeline.tex \
            result.tex \
            thesis.tex \
            references.bib \
            bibunits.sty \
            uwmthesis.sty
	pdflatex thesis && bibtex thesis && bibtex thesis.1 && pdflatex thesis && pdflatex thesis

clean:
	rm -f thesis.pdf *.aux *.bbl *.blg *.log *.lot *.toc *.lof

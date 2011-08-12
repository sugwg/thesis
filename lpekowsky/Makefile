TEXFILES= comparison.tex \
detchar.tex \
introduction.tex \
ninja1.tex \
ninja2.tex \
search.tex \
theory.tex \
thesis.tex \
PNEqns.tex 


PNGFILES=figures/detchar/966222827_940673828_H0_PEM-ISCT1_ACCX_1_00_spectrogram_whitened.png \
figures/detchar/966222827_940673828_H1_LSC-DARM_ERR_1_00_spectrogram_whitened.png \
figures/detchar/968654557_978027343_L1_LSC-DARM_ERR_1_00_spectrogram_whitened.png \
figures/detchar/968654557_997314453_H1_LSC-DARM_ERR_1_00_spectrogram_whitened.png \
figures/detchar/frontendtest_h1_log_2.png \
figures/detchar/frontendtest_l1_log_2.png \
figures/detchar/frontendtest_v1_log_2.png \
figures/detchar/GAUSSIAN_0_UNCLUSTERED_chisq.png \
figures/detchar/H1_0_UNCLUSTERED_chisq.png \
figures/detchar/H1_0_UNCLUSTERED_rate_vs_time.png \
figures/detchar/H1_0_UNCLUSTERED_snr_vs_time.png \
figures/detchar/H1_1_UNCLUSTERED_chisq.png \
figures/detchar/H1_1_UNCLUSTERED_glitchgram.png \
figures/detchar/H1_1_UNCLUSTERED_snr_hist.png \
figures/detchar/H1_4_UNCLUSTERED_chisq.png \
figures/detchar/H1_4_UNCLUSTERED_snr_hist.png \
figures/detchar/hybrid_bank.png \
figures/detchar/LM_H1_16SEC_3_hist.png \
figures/detchar/LM_H1_30MILLISEC_3_hist.png \
figures/detchar/LM_L1_16SEC_3_hist.png \
figures/detchar/LM_L1_30MILLISEC_3_hist.png \
figures/detchar/loudest.png \
figures/detchar/MM_H1_16SEC_3_hist.png \
figures/detchar/MM_H1_30MILLISEC_3_hist.png \
figures/detchar/MM_L1_16SEC_3_hist.png \
figures/detchar/MM_L1_30MILLISEC_3_hist.png \
figures/detchar/vetousage.png

BIBFILES=references.bib

STYFILES=bibunits.sty syrthesis.sty

BSTFILES=

BBLFILES=

default: thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES) $(STYFILES) $(BSTFILES)
	pdflatex thesis && bibtex thesis && pdflatex thesis && pdflatex thesis

gr-qc: thesis.tgz

thesis.tgz: thesis.pdf
	tar -zcvf grqc.tgz $(TEXFILES) $(PNGFILES) $(BBLFILES) $(STYFILES)

clean:
	rm -f thesis.pdf *.aux *.bbl *.blg *.log *.lot *.toc *.lof *.bak *.tgz *.out

TEXFILES=acknowledge.tex \
conclusion.tex \
findchirp.tex \
inspiral.tex \
introduction.tex \
macho.tex \
pipeline.tex \
hardware.tex \
result.tex \
thesis.tex

PNGFILES=figures/conclusion/s3strain.png \
figures/findchirp/impulse_inv_spec.png \
figures/findchirp/impulse_snr.png \
figures/findchirp/impulse_spec.png \
figures/findchirp/impulse_wraparound.png \
figures/findchirp/maxoverchirp.png \
figures/findchirp/rhosq_gaussian_cdf.png \
figures/findchirp/zero_inject_zoom.png \
figures/hardware/calibration.png \
figures/hardware/ifo_inj.png \
figures/hardware/inj_snr.png \
figures/hardware/veto_safe.png \
figures/inspiral/beampattern.png \
figures/inspiral/binary.png \
figures/inspiral/darm.png \
figures/inspiral/deviation.png \
figures/inspiral/euler.png \
figures/inspiral/ifoconfigs.png \
figures/inspiral/ligonoise.png \
figures/inspiral/observatories.png \
figures/inspiral/rings.png \
figures/macho/lensing.png \
figures/macho/m1_hist.png \
figures/macho/ngc3198.png \
figures/macho/noisecurves.png \
figures/macho/scattering.png \
figures/macho/spherical_cartesian.png \
figures/macho/spherical_equatorial.png \
figures/pipeline/G030379-00.png \
figures/pipeline/fake_segs_dag.png \
figures/pipeline/gmst_dist_ratio.png \
figures/pipeline/injection-snrplot.png \
figures/pipeline/injection-ts.png \
figures/pipeline/loudest-snrplot.png \
figures/pipeline/loudest-ts.png \
figures/pipeline/macho_bank.png \
figures/pipeline/s2_coinc_test.png \
figures/pipeline/s2_pipeline.png \
figures/pipeline/s2_segments.png \
figures/pipeline/simple_pipe.png \
figures/pipeline/snr_resample_loss.png \
figures/pipeline/trigger_730592784_as_q.png \
figures/pipeline/trigger_730592784_pob_i.png \
figures/pipeline/trigger_734153360_as_q.png \
figures/pipeline/trigger_734153360_pob_i.png \
figures/result/bank_size.png \
figures/result/bkg.png \
figures/result/bkg_inj.png \
figures/result/bkg_inj_zoom.png \
figures/result/h1_inj_mass_7_0_delta_0_04_chisq_12_5.png \
figures/result/h1_inj_snr_7_0_delta_0_04_chisq_12_5.png \
figures/result/h1_inj_snr_final.png \
figures/result/h1_param_error.png \
figures/result/h1l1_snr_hist_delta_0_04_chisq_12_5.png \
figures/result/h2_param_error.png \
figures/result/l1_inj_snr_7_0_delta_0_04_chisq_5_0.png \
figures/result/l1_inj_snr_final.png \
figures/result/l1_param_error.png \
figures/result/m1m2_found.png \
figures/result/m1m2_missed.png \
figures/result/mchirp_eff.png \
figures/result/mchirp_found_missed.png \
figures/result/s2_macho_range_summary.png \
figures/result/s2_times.png

BIBFILES=papers.bib references.bib

UWMFILES=uwmthesis.sty

STYFILES=bibunits.sty

BSTFILES=vita.bst

BBLFILES=thesis.1.bbl thesis.bbl

default: thesis.pdf

thesis.pdf: $(TEXFILES) $(BIBFILES) $(STYFILES) $(BSTFILES) $(UWMFILES)
	pdflatex thesis && bibtex thesis && bibtex thesis.1 && pdflatex thesis && pdflatex thesis

gr-qc: thesis.tgz

thesis.tgz: thesis.pdf
	tar -zcvf grqc.tgz $(TEXFILES) $(PNGFILES) $(BBLFILES) $(UWMFILES)

clean:
	rm -f thesis.pdf *.aux *.bbl *.blg *.log *.lot *.toc *.lof *.bak *.tgz

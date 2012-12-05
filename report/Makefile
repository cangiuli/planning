.PHONY: clean

report.pdf: report.tex citations.bib concurrent.tex functional.tex appendix.tex
	pdflatex $< ; bibtex $(<:%.tex=%) ; pdflatex $< ; pdflatex $<

clean:
	-rm *.aux *.log *.out

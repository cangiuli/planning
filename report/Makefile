.PHONY: clean

report.pdf: report.tex citations.bib
	pdflatex $< ; bibtex $(<:%.tex=%) ; pdflatex $< ; pdflatex $<

clean:
	-rm *.aux *.log *.out

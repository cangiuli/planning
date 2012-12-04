.PHONY: clean

report.pdf: report.tex citations.bib concurrent.tex concurrent-results.tex
	pdflatex $< ; bibtex $(<:%.tex=%) ; pdflatex $< ; pdflatex $<

clean:
	-rm *.aux *.log *.out

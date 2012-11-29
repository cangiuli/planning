parse-files:	lang.grm.tmp lang.lex.tmp
lang.grm.tmp: 	lang.grm
				ml-yacc lang.grm
lang.lex.tmp: 	lang.lex
				ml-lex lang.lex
clean:	DUMMY
	rm -f *.lex.* *.grm.*

DUMMY:


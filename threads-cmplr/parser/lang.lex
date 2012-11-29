structure Tokens = Tokens

type pos = int
type svalue = Tokens.svalue
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult= (svalue,pos) token

val pos = ref 0

exception Illegal_character of pos

local
  val commentLevel = ref 0
in
  fun enterComment () =
      commentLevel := !commentLevel + 1

  fun exitComment () =
      (commentLevel := !commentLevel - 1;
       !commentLevel = 0)

  fun eof () =
      if !commentLevel <> 0
      then (commentLevel := 0; raise Fail "unclosed comment")
      else Tokens.EOF(!pos,!pos)
end

%%
%header (functor C1_LexFun(structure Tokens: C1_TOKENS));

%full
%s COMMENT;

alpha=[A-Za-z];
digit=[0-9];
any = [@a-zA-Z0-9_];
special=[`~!@#$%^&*-=+<>?_];

ws = [\ \t];

%%
<INITIAL> \n        => (pos := (!pos) + 1; lex());
<INITIAL> {ws}+     => (lex());
<INITIAL> "if"      => (Tokens.IF(!pos,!pos));
<INITIAL> "else"    => (Tokens.ELSE(!pos,!pos));
<INITIAL> "while"   => (Tokens.WHILE(!pos,!pos));
<INITIAL> "fork"    => (Tokens.FORK(!pos,!pos));
<INITIAL> "int"     => (Tokens.INT(!pos,!pos));
<INITIAL> "{"       => (Tokens.LBRACE(!pos,!pos));
<INITIAL> "}"       => (Tokens.RBRACE(!pos,!pos));
<INITIAL> "("       => (Tokens.LPAREN(!pos,!pos));
<INITIAL> ")"       => (Tokens.RPAREN(!pos,!pos));
<INITIAL> "="       => (Tokens.EQUALS(!pos,!pos));
<INITIAL> "++"      => (Tokens.INC(!pos,!pos));
<INITIAL> "--"      => (Tokens.DEC(!pos,!pos));
<INITIAL> ";"       => (Tokens.SEMI(!pos,!pos));
<INITIAL> ","       => (Tokens.COMMA(!pos,!pos));
<INITIAL> "!"       => (Tokens.BANG(!pos,!pos));
<INITIAL> {alpha}{any}* => (Tokens.IDENT(yytext,!pos,!pos));
<INITIAL> {digit}+ => (Tokens.NUMBER((valOf o Int.fromString) yytext,
                                     !pos, !pos));
<INITIAL> {special} => (Tokens.IDENT(yytext,!pos,!pos));

<INITIAL> "/*"        => (YYBEGIN COMMENT; enterComment (); lex ());
<INITIAL> "*/"        => (raise Fail "unmatched close comment";
                          lex ());

<COMMENT> "/*"        => (enterComment (); continue());
<COMMENT> "*/"        => (if exitComment () then YYBEGIN INITIAL else (); continue ());
<COMMENT> \n          => (pos := (!pos) + 1; continue());
<COMMENT> .           => (lex ());

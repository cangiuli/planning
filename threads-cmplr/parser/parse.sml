structure Parse  =
struct
  exception Parse of string    

  structure C1LrVals = C1LrValsFun(structure Token = LrParser.Token)
  structure Lex = C1_LexFun (structure Tokens = C1LrVals.Tokens)
  structure C1P = Join (structure ParserData = C1LrVals.ParserData
                         structure Lex = Lex
                         structure LrParser = LrParser)

  (* Turn a stream into a function that returns a new value
   * on each application. This is then given to lex for lex
   * to use convert into a different sort of stream. Sigh. *)
  fun streamreader s =
      let val stream = ref s
          fun reader n =
              case Stream.force (!stream) of
                  Stream.Nil => ""
                | Stream.Cons (x, s) => (stream := s; str x)
      in reader end

  fun error (s, pos, pos') = raise Parse s

  fun is_eof stream =
      let val EOF_token = C1LrVals.Tokens.EOF (0, 0)
          val (token, _) = LrParser.Stream.get stream
      in
          LrParser.Token.sameToken (token, EOF_token)
      end

  fun parse stream = 
      let
          val lexer = C1P.makeLexer (streamreader stream)
          fun parse' lexer =
              let
                  val (res, lexer') = C1P.parse (1, lexer, error, ())
              in res end
          in parse' lexer end

end

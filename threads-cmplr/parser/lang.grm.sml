functor C1LrValsFun(structure Token : TOKEN)
 : sig structure ParserData : PARSER_DATA
       structure Tokens : C1_TOKENS
   end
 = 
struct
structure ParserData=
struct
structure Header = 
struct
structure L = C1Named
exception Parse of string


end
structure LrTable = Token.LrTable
structure Token = Token
local open LrTable in 
val table=let val actionRows =
"\
\\001\000\001\000\000\000\000\000\
\\001\000\002\000\009\000\000\000\
\\001\000\002\000\025\000\006\000\024\000\008\000\023\000\009\000\022\000\
\\011\000\016\000\016\000\021\000\000\000\
\\001\000\002\000\035\000\000\000\
\\001\000\002\000\039\000\003\000\038\000\018\000\037\000\000\000\
\\001\000\002\000\046\000\000\000\
\\001\000\002\000\049\000\000\000\
\\001\000\003\000\014\000\000\000\
\\001\000\004\000\034\000\005\000\033\000\015\000\032\000\000\000\
\\001\000\011\000\016\000\000\000\
\\001\000\012\000\028\000\000\000\
\\001\000\013\000\011\000\000\000\
\\001\000\013\000\029\000\000\000\
\\001\000\013\000\030\000\000\000\
\\001\000\013\000\031\000\000\000\
\\001\000\014\000\013\000\000\000\
\\001\000\014\000\045\000\000\000\
\\001\000\014\000\047\000\000\000\
\\001\000\014\000\052\000\000\000\
\\001\000\015\000\012\000\000\000\
\\001\000\016\000\017\000\000\000\
\\001\000\016\000\042\000\000\000\
\\001\000\016\000\043\000\000\000\
\\001\000\016\000\048\000\000\000\
\\001\000\016\000\055\000\000\000\
\\001\000\017\000\044\000\000\000\
\\058\000\000\000\
\\059\000\000\000\
\\060\000\010\000\005\000\000\000\
\\061\000\000\000\
\\062\000\002\000\008\000\000\000\
\\063\000\000\000\
\\064\000\000\000\
\\065\000\000\000\
\\066\000\002\000\025\000\006\000\024\000\008\000\023\000\009\000\022\000\
\\011\000\016\000\016\000\021\000\000\000\
\\067\000\000\000\
\\068\000\000\000\
\\069\000\000\000\
\\070\000\000\000\
\\071\000\000\000\
\\072\000\000\000\
\\073\000\000\000\
\\074\000\000\000\
\\075\000\000\000\
\\076\000\007\000\054\000\000\000\
\\077\000\000\000\
\\078\000\000\000\
\\079\000\000\000\
\\080\000\000\000\
\"
val actionRowNumbers =
"\028\000\030\000\026\000\001\000\
\\030\000\027\000\011\000\019\000\
\\031\000\015\000\007\000\009\000\
\\020\000\032\000\034\000\028\000\
\\034\000\010\000\040\000\036\000\
\\012\000\013\000\014\000\008\000\
\\029\000\035\000\033\000\003\000\
\\004\000\004\000\004\000\021\000\
\\022\000\025\000\016\000\005\000\
\\047\000\046\000\017\000\023\000\
\\042\000\041\000\006\000\002\000\
\\048\000\002\000\037\000\018\000\
\\039\000\044\000\024\000\038\000\
\\002\000\043\000\045\000\000\000"
val gotoT =
"\
\\001\000\055\000\002\000\002\000\003\000\001\000\000\000\
\\004\000\005\000\005\000\004\000\000\000\
\\000\000\
\\000\000\
\\004\000\008\000\005\000\004\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\006\000\013\000\000\000\
\\000\000\
\\000\000\
\\006\000\018\000\007\000\017\000\008\000\016\000\000\000\
\\003\000\024\000\000\000\
\\006\000\018\000\007\000\025\000\008\000\016\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\010\000\034\000\000\000\
\\010\000\038\000\000\000\
\\010\000\039\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\006\000\018\000\008\000\048\000\000\000\
\\000\000\
\\006\000\018\000\008\000\049\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\009\000\051\000\000\000\
\\000\000\
\\000\000\
\\006\000\018\000\008\000\054\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\"
val numstates = 56
val numrules = 23
val s = ref "" and index = ref 0
val string_to_int = fn () => 
let val i = !index
in index := i+2; Char.ord(String.sub(!s,i)) + Char.ord(String.sub(!s,i+1)) * 256
end
val string_to_list = fn s' =>
    let val len = String.size s'
        fun f () =
           if !index < len then string_to_int() :: f()
           else nil
   in index := 0; s := s'; f ()
   end
val string_to_pairlist = fn (conv_key,conv_entry) =>
     let fun f () =
         case string_to_int()
         of 0 => EMPTY
          | n => PAIR(conv_key (n-1),conv_entry (string_to_int()),f())
     in f
     end
val string_to_pairlist_default = fn (conv_key,conv_entry) =>
    let val conv_row = string_to_pairlist(conv_key,conv_entry)
    in fn () =>
       let val default = conv_entry(string_to_int())
           val row = conv_row()
       in (row,default)
       end
   end
val string_to_table = fn (convert_row,s') =>
    let val len = String.size s'
        fun f ()=
           if !index < len then convert_row() :: f()
           else nil
     in (s := s'; index := 0; f ())
     end
local
  val memo = Array.array(numstates+numrules,ERROR)
  val _ =let fun g i=(Array.update(memo,i,REDUCE(i-numstates)); g(i+1))
       fun f i =
            if i=numstates then g i
            else (Array.update(memo,i,SHIFT (STATE i)); f (i+1))
          in f 0 handle Subscript => ()
          end
in
val entry_to_action = fn 0 => ACCEPT | 1 => ERROR | j => Array.sub(memo,(j-2))
end
val gotoT=Array.fromList(string_to_table(string_to_pairlist(NT,STATE),gotoT))
val actionRows=string_to_table(string_to_pairlist_default(T,entry_to_action),actionRows)
val actionRowNumbers = string_to_list actionRowNumbers
val actionT = let val actionRowLookUp=
let val a=Array.fromList(actionRows) in fn i=>Array.sub(a,i) end
in Array.fromList(map actionRowLookUp actionRowNumbers)
end
in LrTable.mkLrTable {actions=actionT,gotos=gotoT,numRules=numrules,
numStates=numstates,initialState=STATE 0}
end
end
local open Header in
type pos = int
type arg = unit
structure MlyValue = 
struct
datatype svalue = VOID | ntVOID of unit ->  unit
 | NUMBER of unit ->  (int) | IDENT of unit ->  (string)
 | exp of unit ->  (L.exp) | elsestm of unit ->  (L.stm)
 | stm of unit ->  (L.stm) | stms of unit ->  (L.stm)
 | block of unit ->  (L.stm) | fdef of unit ->  (L.function)
 | functions of unit ->  (L.function list)
 | globals of unit ->  (L.global list)
 | program of unit ->  (L.program) | start of unit ->  (L.program)
end
type svalue = MlyValue.svalue
type result = L.program
end
structure EC=
struct
open LrTable
infix 5 $$
fun x $$ y = y::x
val is_keyword =
fn _ => false
val preferred_change : (term list * term list) list = 
nil
val noShift = 
fn (T 0) => true | _ => false
val showTerminal =
fn (T 0) => "EOF"
  | (T 1) => "IDENT"
  | (T 2) => "NUMBER"
  | (T 3) => "INC"
  | (T 4) => "DEC"
  | (T 5) => "IF"
  | (T 6) => "ELSE"
  | (T 7) => "WHILE"
  | (T 8) => "FORK"
  | (T 9) => "INT"
  | (T 10) => "LBRACE"
  | (T 11) => "RBRACE"
  | (T 12) => "LPAREN"
  | (T 13) => "RPAREN"
  | (T 14) => "EQUALS"
  | (T 15) => "SEMI"
  | (T 16) => "COMMA"
  | (T 17) => "BANG"
  | _ => "bogus-term"
local open Header in
val errtermvalue=
fn _ => MlyValue.VOID
end
val terms : term list = nil
 $$ (T 17) $$ (T 16) $$ (T 15) $$ (T 14) $$ (T 13) $$ (T 12) $$ (T 11)
 $$ (T 10) $$ (T 9) $$ (T 8) $$ (T 7) $$ (T 6) $$ (T 5) $$ (T 4) $$ 
(T 3) $$ (T 0)end
structure Actions =
struct 
exception mlyAction of int
local open Header in
val actions = 
fn (i392,defaultPos,stack,
    (()):arg) =>
case (i392,stack)
of  ( 0, ( ( _, ( MlyValue.program program1, program1left, 
program1right)) :: rest671)) => let val  result = MlyValue.start (fn _
 => let val  (program as program1) = program1 ()
 in (program)
end)
 in ( LrTable.NT 0, ( result, program1left, program1right), rest671)

end
|  ( 1, ( ( _, ( MlyValue.functions functions1, _, functions1right))
 :: ( _, ( MlyValue.globals globals1, globals1left, _)) :: rest671))
 => let val  result = MlyValue.program (fn _ => let val  (globals as 
globals1) = globals1 ()
 val  (functions as functions1) = functions1 ()
 in (globals, functions)
end)
 in ( LrTable.NT 1, ( result, globals1left, functions1right), rest671)

end
|  ( 2, ( rest671)) => let val  result = MlyValue.globals (fn _ => ([]
))
 in ( LrTable.NT 2, ( result, defaultPos, defaultPos), rest671)
end
|  ( 3, ( ( _, ( MlyValue.globals globals1, _, globals1right)) :: _ ::
 ( _, ( MlyValue.NUMBER NUMBER1, _, _)) :: _ :: ( _, ( MlyValue.IDENT 
IDENT1, _, _)) :: ( _, ( _, INT1left, _)) :: rest671)) => let val  
result = MlyValue.globals (fn _ => let val  (IDENT as IDENT1) = IDENT1
 ()
 val  (NUMBER as NUMBER1) = NUMBER1 ()
 val  (globals as globals1) = globals1 ()
 in ((IDENT, NUMBER) :: globals)
end)
 in ( LrTable.NT 2, ( result, INT1left, globals1right), rest671)
end
|  ( 4, ( rest671)) => let val  result = MlyValue.functions (fn _ => (
[]))
 in ( LrTable.NT 3, ( result, defaultPos, defaultPos), rest671)
end
|  ( 5, ( ( _, ( MlyValue.functions functions1, _, functions1right))
 :: ( _, ( MlyValue.fdef fdef1, fdef1left, _)) :: rest671)) => let
 val  result = MlyValue.functions (fn _ => let val  (fdef as fdef1) = 
fdef1 ()
 val  (functions as functions1) = functions1 ()
 in (fdef :: functions)
end)
 in ( LrTable.NT 3, ( result, fdef1left, functions1right), rest671)

end
|  ( 6, ( ( _, ( MlyValue.block block1, _, block1right)) :: _ :: _ :: 
( _, ( MlyValue.IDENT IDENT1, IDENT1left, _)) :: rest671)) => let val 
 result = MlyValue.fdef (fn _ => let val  (IDENT as IDENT1) = IDENT1
 ()
 val  (block as block1) = block1 ()
 in (IDENT, block)
end)
 in ( LrTable.NT 4, ( result, IDENT1left, block1right), rest671)
end
|  ( 7, ( ( _, ( _, _, RBRACE1right)) :: ( _, ( MlyValue.stms stms1, _
, _)) :: ( _, ( _, LBRACE1left, _)) :: rest671)) => let val  result = 
MlyValue.block (fn _ => let val  (stms as stms1) = stms1 ()
 in (stms)
end)
 in ( LrTable.NT 5, ( result, LBRACE1left, RBRACE1right), rest671)
end
|  ( 8, ( rest671)) => let val  result = MlyValue.stms (fn _ => (
L.SNil))
 in ( LrTable.NT 6, ( result, defaultPos, defaultPos), rest671)
end
|  ( 9, ( ( _, ( MlyValue.stms stms1, _, stms1right)) :: ( _, ( 
MlyValue.stm stm1, stm1left, _)) :: rest671)) => let val  result = 
MlyValue.stms (fn _ => let val  (stm as stm1) = stm1 ()
 val  (stms as stms1) = stms1 ()
 in (
case stms of
                                      L.SNil => stm
                                    | _ => L.SSeq (stm, stms)
)
end)
 in ( LrTable.NT 6, ( result, stm1left, stms1right), rest671)
end
|  ( 10, ( ( _, ( _, SEMI1left, SEMI1right)) :: rest671)) => let val  
result = MlyValue.stm (fn _ => (L.SNil))
 in ( LrTable.NT 7, ( result, SEMI1left, SEMI1right), rest671)
end
|  ( 11, ( ( _, ( _, _, SEMI1right)) :: ( _, ( MlyValue.exp exp1, _, _
)) :: _ :: ( _, ( MlyValue.IDENT IDENT1, IDENT1left, _)) :: rest671))
 => let val  result = MlyValue.stm (fn _ => let val  (IDENT as IDENT1)
 = IDENT1 ()
 val  (exp as exp1) = exp1 ()
 in (L.SAssign (IDENT, exp))
end)
 in ( LrTable.NT 7, ( result, IDENT1left, SEMI1right), rest671)
end
|  ( 12, ( ( _, ( MlyValue.elsestm elsestm1, _, elsestm1right)) :: ( _
, ( MlyValue.stm stm1, _, _)) :: _ :: ( _, ( MlyValue.exp exp1, _, _))
 :: _ :: ( _, ( _, IF1left, _)) :: rest671)) => let val  result = 
MlyValue.stm (fn _ => let val  (exp as exp1) = exp1 ()
 val  (stm as stm1) = stm1 ()
 val  (elsestm as elsestm1) = elsestm1 ()
 in (L.SIf (exp, stm, elsestm))
end)
 in ( LrTable.NT 7, ( result, IF1left, elsestm1right), rest671)
end
|  ( 13, ( ( _, ( MlyValue.stm stm1, _, stm1right)) :: _ :: ( _, ( 
MlyValue.exp exp1, _, _)) :: _ :: ( _, ( _, WHILE1left, _)) :: rest671
)) => let val  result = MlyValue.stm (fn _ => let val  (exp as exp1) =
 exp1 ()
 val  (stm as stm1) = stm1 ()
 in (L.SWhile (exp, stm))
end)
 in ( LrTable.NT 7, ( result, WHILE1left, stm1right), rest671)
end
|  ( 14, ( ( _, ( MlyValue.block block1, block1left, block1right)) :: 
rest671)) => let val  result = MlyValue.stm (fn _ => let val  (block
 as block1) = block1 ()
 in (block)
end)
 in ( LrTable.NT 7, ( result, block1left, block1right), rest671)
end
|  ( 15, ( ( _, ( _, _, SEMI1right)) :: _ :: ( _, ( MlyValue.IDENT 
IDENT1, IDENT1left, _)) :: rest671)) => let val  result = MlyValue.stm
 (fn _ => let val  (IDENT as IDENT1) = IDENT1 ()
 in (L.SInc IDENT)
end)
 in ( LrTable.NT 7, ( result, IDENT1left, SEMI1right), rest671)
end
|  ( 16, ( ( _, ( _, _, SEMI1right)) :: _ :: ( _, ( MlyValue.IDENT 
IDENT1, IDENT1left, _)) :: rest671)) => let val  result = MlyValue.stm
 (fn _ => let val  (IDENT as IDENT1) = IDENT1 ()
 in (L.SDec IDENT)
end)
 in ( LrTable.NT 7, ( result, IDENT1left, SEMI1right), rest671)
end
|  ( 17, ( ( _, ( _, _, SEMI1right)) :: _ :: ( _, ( MlyValue.IDENT 
IDENT2, _, _)) :: _ :: ( _, ( MlyValue.IDENT IDENT1, _, _)) :: _ :: (
 _, ( _, FORK1left, _)) :: rest671)) => let val  result = MlyValue.stm
 (fn _ => let val  IDENT1 = IDENT1 ()
 val  IDENT2 = IDENT2 ()
 in (L.SFork (IDENT1, IDENT2))
end)
 in ( LrTable.NT 7, ( result, FORK1left, SEMI1right), rest671)
end
|  ( 18, ( rest671)) => let val  result = MlyValue.elsestm (fn _ => (
L.SNil))
 in ( LrTable.NT 8, ( result, defaultPos, defaultPos), rest671)
end
|  ( 19, ( ( _, ( MlyValue.stm stm1, _, stm1right)) :: ( _, ( _, 
ELSE1left, _)) :: rest671)) => let val  result = MlyValue.elsestm (fn
 _ => let val  (stm as stm1) = stm1 ()
 in (stm)
end)
 in ( LrTable.NT 8, ( result, ELSE1left, stm1right), rest671)
end
|  ( 20, ( ( _, ( MlyValue.IDENT IDENT1, IDENT1left, IDENT1right)) :: 
rest671)) => let val  result = MlyValue.exp (fn _ => let val  (IDENT
 as IDENT1) = IDENT1 ()
 in (L.EVar IDENT)
end)
 in ( LrTable.NT 9, ( result, IDENT1left, IDENT1right), rest671)
end
|  ( 21, ( ( _, ( MlyValue.NUMBER NUMBER1, NUMBER1left, NUMBER1right))
 :: rest671)) => let val  result = MlyValue.exp (fn _ => let val  (
NUMBER as NUMBER1) = NUMBER1 ()
 in (L.ENum NUMBER)
end)
 in ( LrTable.NT 9, ( result, NUMBER1left, NUMBER1right), rest671)
end
|  ( 22, ( ( _, ( MlyValue.IDENT IDENT1, _, IDENT1right)) :: ( _, ( _,
 BANG1left, _)) :: rest671)) => let val  result = MlyValue.exp (fn _
 => let val  (IDENT as IDENT1) = IDENT1 ()
 in (L.ENot IDENT)
end)
 in ( LrTable.NT 9, ( result, BANG1left, IDENT1right), rest671)
end
| _ => raise (mlyAction i392)
end
val void = MlyValue.VOID
val extract = fn a => (fn MlyValue.start x => x
| _ => let exception ParseInternal
	in raise ParseInternal end) a ()
end
end
structure Tokens : C1_TOKENS =
struct
type svalue = ParserData.svalue
type ('a,'b) token = ('a,'b) Token.token
fun EOF (p1,p2) = Token.TOKEN (ParserData.LrTable.T 0,(
ParserData.MlyValue.VOID,p1,p2))
fun IDENT (i,p1,p2) = Token.TOKEN (ParserData.LrTable.T 1,(
ParserData.MlyValue.IDENT (fn () => i),p1,p2))
fun NUMBER (i,p1,p2) = Token.TOKEN (ParserData.LrTable.T 2,(
ParserData.MlyValue.NUMBER (fn () => i),p1,p2))
fun INC (p1,p2) = Token.TOKEN (ParserData.LrTable.T 3,(
ParserData.MlyValue.VOID,p1,p2))
fun DEC (p1,p2) = Token.TOKEN (ParserData.LrTable.T 4,(
ParserData.MlyValue.VOID,p1,p2))
fun IF (p1,p2) = Token.TOKEN (ParserData.LrTable.T 5,(
ParserData.MlyValue.VOID,p1,p2))
fun ELSE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 6,(
ParserData.MlyValue.VOID,p1,p2))
fun WHILE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 7,(
ParserData.MlyValue.VOID,p1,p2))
fun FORK (p1,p2) = Token.TOKEN (ParserData.LrTable.T 8,(
ParserData.MlyValue.VOID,p1,p2))
fun INT (p1,p2) = Token.TOKEN (ParserData.LrTable.T 9,(
ParserData.MlyValue.VOID,p1,p2))
fun LBRACE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 10,(
ParserData.MlyValue.VOID,p1,p2))
fun RBRACE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 11,(
ParserData.MlyValue.VOID,p1,p2))
fun LPAREN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 12,(
ParserData.MlyValue.VOID,p1,p2))
fun RPAREN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 13,(
ParserData.MlyValue.VOID,p1,p2))
fun EQUALS (p1,p2) = Token.TOKEN (ParserData.LrTable.T 14,(
ParserData.MlyValue.VOID,p1,p2))
fun SEMI (p1,p2) = Token.TOKEN (ParserData.LrTable.T 15,(
ParserData.MlyValue.VOID,p1,p2))
fun COMMA (p1,p2) = Token.TOKEN (ParserData.LrTable.T 16,(
ParserData.MlyValue.VOID,p1,p2))
fun BANG (p1,p2) = Token.TOKEN (ParserData.LrTable.T 17,(
ParserData.MlyValue.VOID,p1,p2))
end
end

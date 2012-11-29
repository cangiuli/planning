structure Exec(* : EXEC*) =
struct
  exception InternalError

 (* The streams from the input library are of type (char * char list)
   * stream. The char list is "for error reporting". We don't care, so
   * we throw it out. *)
  fun cleanupStream s = Stream.map (fn (x, _) => x) s

  fun println s = print (s ^ "\n")

(*
  fun errorMessage e =
      case e of
          Parse.Parse s => "parse error: " ^ s
        | C1Properties.PropertyBroken s => s
        | Compiler.CompileError s => s
        | Typechecker.TypeExpError s => s
        | Typechecker.TypeCmdError s => s
        | Translator.TranslationError s => s
        | Evaluator.StuckExp s => s
        | Evaluator.StuckCmd s => s
        | _ => exnMessage e

  fun printerror e = println (errorMessage e)
*)

  (* parses the contents of a file as a C1 program *)
  val readFile = Parse.parse o cleanupStream o Input.readFile

end

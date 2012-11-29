signature EXEC = 
sig
  (* useful for testing
   * -parses the contents of the specified file as a C1 program
   * -verifies certain static properties
   * -compiles it to MA 
   * -typechecks it
   * -executes it to a final state of a nat cmd
   * -prints the value of this nat cmd as an int
   * -handles and pretty prints all exceptions
   *)
  val execProgram : string -> unit

  (* useful for debugging
   * -parses the contents of the specified file as a C1 program
   * -verifies certain static properties
   * -compiles it to MA 
   * -typechecks it
   * -executes it to a final state of a nat cmd
   * -returns the value of this nat cmd as an int
   *)
  val evalProgram : string -> int
end

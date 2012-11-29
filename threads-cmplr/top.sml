structure Toplevel =
struct
  fun equals x y = x = y
  fun getBasename s =
      let val filename = List.last (String.tokens (equals #"/")s )
          val basename = hd (String.tokens (equals #".") filename)
      in basename end

  fun compileStr inputFile =
      let val ast = Exec.readFile inputFile
          val labeled = Compile.compile ast
          val unlabeled = RemoveLabels.convert labeled
          val output = Output.emitProgram (getBasename inputFile) unlabeled
      in output end

  fun compile inputFile outputFile =
      let val output = compileStr inputFile
          val file = TextIO.openOut outputFile
          val () = TextIO.output (file, output)
          val () = TextIO.closeOut file
      in () end


end

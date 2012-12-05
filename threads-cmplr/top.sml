structure Toplevel =
struct
  fun cleanupStream s = Stream.map (fn (x, _) => x) s
  val readFile = Parse.parse o cleanupStream o Input.readFile

  fun equals x y = x = y
  fun getBasename s =
      let val filename = List.last (String.tokens (equals #"/")s )
          val basename = hd (String.tokens (equals #".") filename)
      in basename end

  fun compileStr inputFile goals outputFile =
      let val ast = readFile inputFile
          val labeled = Compile.compile ast
          val unlabeled = RemoveLabels.convert labeled
          val output = Output.emitProgram (getBasename outputFile) unlabeled goals
      in output end

  fun compile inputFile goals outputFile =
      let val output = compileStr inputFile goals outputFile
          val file = TextIO.openOut outputFile
          val () = TextIO.output (file, output)
          val () = TextIO.closeOut file
      in () end


end

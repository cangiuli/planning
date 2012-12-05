structure Output =
struct
  structure C = C1Named
  structure S = Target

  val indent = "    "
  val indent2 = indent ^ indent
  val goal_indent = "            "

  fun shouldPlan C.Plan = "; A plan SHOULD be found\n"
    | shouldPlan C.NoPlan = "; A plan should NOT be found\n"

  fun initial_boilerplate name plan =
      "; THIS IS GENERATED CODE: DO NOT EDIT\n" ^
      shouldPlan plan ^
      "(define (problem " ^ name ^ ")\n" ^
      "    (:domain threads)\n" ^
      "    (:objects\n" ^
      "        n0 n1 n2 n3 n4 n5 n6 - number\n" ^
      "        out - label\n"

  val mid_boilerplate =
      "\n" ^
      "    )\n" ^
      "    (:init\n" ^
      "        (succ n0 n1) (succ n1 n2) (succ n2 n3)\n" ^
      "        (succ n3 n4) (succ n4 n5) (succ n5 n6)\n\n"

  fun emitDoneGoal C.Finish = "            (done out)\n"
    | emitDoneGoal C.NotFinish = ""

  fun emitLabel func n = func ^ Int.toString n
  fun emitNumber n = "n" ^ Int.toString n

  fun emitBinding (v, n) =
      goal_indent ^ "(value " ^ v ^ " " ^ emitNumber n ^ ")\n"

  fun end_boilerplate doneGoal bindings =
    "        (eval main0 out)\n" ^
    "    )\n" ^
    "    (:goal (and\n" ^
    emitDoneGoal doneGoal ^
    String.concat (map emitBinding bindings) ^
    "        )\n" ^
    "    )\n" ^
    ")\n"

  fun emitGlobalObjects globals =
      let val names = map Util.first globals
      in indent2 ^ String.concatWith " " names ^ " - label\n\n" end



  fun emitFunctionLabels (name, stmts) =
      let
          val labels = List.tabulate (List.length stmts, emitLabel name)
      in indent2 ^ String.concatWith " " labels ^ "\n" end

  fun emitLabels functions =
      String.concat (map emitFunctionLabels functions) ^ indent2 ^ "- label\n"

  fun emitGlobals globals =
      let fun emitGlobal (name, value) =
              indent2 ^ "(value " ^ name ^ " " ^ emitNumber value ^ ")\n"
      in indent2 ^ "; .data\n" ^
         String.concat (map emitGlobal globals) ^ "\n"
      end

  fun emitCode func me oper args =
      indent2 ^ "(" ^
      String.concatWith " " (oper :: emitLabel func me :: args) ^
      ")\n"

  fun emitOper func next me oper =
      let fun emit opername args = emitCode func me opername
                                            (emitLabel func next :: args)
      in (case oper of
              S.OIncr v => emit "incr" [v]
            | S.ODecr v => emit "decr" [v]
            | S.OLoad (v1, v2) => emit "load" [v1, v2]
            | S.OSet (v, n) => emit "set" [v, emitNumber n]
            | S.OFork (t1, t2) => emit "fork" [emitLabel t1 0, emitLabel t2 0]
         )
      end

  fun emitInstr func me instr =
      (case instr of
           S.IOper (oper, next) => emitOper func next me oper
         | S.IExit => emitCode func me "exit" []
         | S.IBranch (v, l1, l2) =>
           emitCode func me "branch"
                    [v, emitLabel func l1 , emitLabel func l2])

  fun emitFunction (funcName, instrs) =
      let val body = String.concat (Util.mapi (emitInstr funcName) instrs)
      in indent2 ^ "; " ^ funcName ^ "\n" ^ body ^ "\n" end

  fun emitFunctions functions =
      indent2 ^ "; .text\n" ^ String.concat (map emitFunction functions)

  fun emitProgram name (globals, functions)
                  (shouldFinish, shouldPlan, bindings) =
      initial_boilerplate name shouldPlan ^
      emitGlobalObjects globals ^
      emitLabels functions ^
      mid_boilerplate ^
      emitGlobals globals ^
      emitFunctions functions ^
      end_boilerplate shouldFinish bindings


end

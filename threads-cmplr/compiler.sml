(* Final target language *)
structure Target =
struct
  type label = int
  type var = string

  datatype operation =
           OIncr of var
         | ODecr of var
         | OLoad of var * var
         | OSet of var * int
         | OFork of string * string

  datatype instr =
           IOper of operation * label
         | IBranch of var * label * label (* true, false *)
         | IExit

end

(* Structure for representing and generating unique labels *)
signature LABEL =
sig
  type t
  val newlabel : string -> t
  val equal : (t * t) -> bool
  val compare : (t * t) -> order
  val toString : t -> string
end

structure Label :(*>*) LABEL =
struct
  type t = (string * int)
  val ctr = ref 0
  fun newlabel s = (ctr := !ctr + 1; (s, !ctr))
  fun equal ((_, id1) : t, (_, id2)) = (id1 = id2)
  fun compare ((_, id1), (_, id2)) = Int.compare (id1, id2)
  fun toString (s, id) = s ^ "@" ^ (Int.toString id)
end

structure LabelMap = SplayMapFn(struct
                                  type ord_key = Label.t
                                  val compare = Label.compare
                                end)

(* A target language that has labels in it. *)
structure LabeledTarget =
struct
  type var = string

  datatype target = TLabel of Label.t | TNext

  datatype operation = datatype Target.operation

  datatype instr =
           IOper of operation * target
         | IBranch of var * target * target (* true, false *)
         | IExit
         | ILabel of Label.t
end


structure RemoveLabels =
struct
  structure S = LabeledTarget
  structure D = Target
  structure LM = LabelMap

  local
      fun update (S.ILabel l, (map, code, n)) =
          (LM.insert(map, l, n), code, n)
        | update (ins, (map, code, n)) =
          (map, ins :: code, n+1)
      (* Build a map of labels to line numbers as well as a list of
       * the code with the labels removed. *)
      fun strip_labels code =
          let val (map, rcode, _) = foldl update (LM.empty, nil, 0) code
          in (map, rev rcode)
          end
  in
  (* Convert a labeled register machine program into a stock one *)
  fun convert code =
      let
          val (map, code) = strip_labels code
          fun lookup _ (S.TLabel l) =
              (case LabelMap.find(map, l) of
                   SOME x => x
                 | NONE => raise Fail (Label.toString l))
            | lookup i S.TNext = i+1

          fun patch _ (S.ILabel _) = raise Fail "woops"
            | patch _ S.IExit = D.IExit
            | patch i (S.IOper (oper, l)) = D.IOper (oper, lookup i l)
            | patch i (S.IBranch (v, l1, l2)) =
              D.IBranch (v, lookup i l1, lookup i l2)
      in
          Util.mapi patch code
      end
  end
end


structure Compile =
struct
  structure S = C1Named
  structure D = LabeledTarget
  structure L = Label

  val a_variable = ref "x"
  fun nop () = D.OLoad (!a_variable, !a_variable)

  fun compileStm next stm =
      let fun oper x = [D.IOper (x, next)]
          fun handleBranch e (true_targ,true_code) (false_targ,false_code) =
              (case e of
                   S.ENum 0 => false_code
                 | S.ENum _ => true_code
                 | S.EVar x =>
                   [D.IBranch (x, true_targ, false_targ)] @
                   true_code @ false_code
                 | S.ENot x =>
                   [D.IBranch (x, false_targ, true_targ)] @
                   true_code @ false_code)

          fun handleExit D.TNext =
              let val exit = L.newlabel "exit"
              in (D.TLabel exit, [D.ILabel exit]) end
            | handleExit target = (target, [])

      in

      (case stm of
           (* SNil should only come up in stupid cases. *)
           S.SNil => oper (nop ())
         | S.SAssign (v1, S.EVar v2) =>
           oper (D.OLoad (v1, v2))
         | S.SAssign (v1, S.ENum n) =>
           oper (D.OSet (v1, n))
         | S.SAssign _ => raise Fail "stop that"

         | S.SInc v => oper (D.OIncr v)
         | S.SDec v => oper (D.ODecr v)
         | S.SFork (t1, t2) => oper (D.OFork (t1, t2))
         | S.SSeq (s1, s2) => compileStm D.TNext s1 @ compileStm next s2

         (* Constant control flow functions *)
(*
         | S.SIf (S.ENum 0, _, s2) => compileStm next s2
         | S.SIf (S.ENum _, s1, _) => compileStm next s1
         | S.SWhile (S.ENum 0, _) => compileStm next S.SNil
         | S.SWhile (S.ENum _, body) =>
           let val l = L.newlabel "infinite loop branch"
           in D.ILabel l :: compileStm (D.TLabel l) body end
*)
         | S.SIf (e, s1, s2) =>
           let val (exit, exit_code) = handleExit next
               val branch_code = handleBranch
                                     e
                                     (compileBranch exit s1)
                                     (compileBranch exit s2)
           in branch_code @ exit_code end
         (* This is an awful hack to make "while (1) {}" work. *)
         | S.SWhile (S.ENum n, S.SNil) =>
           compileStm next (S.SWhile (S.ENum n, S.SSeq (S.SNil, S.SNil)))

         | S.SWhile (e, body) =>
           let val top = L.newlabel "loop top"
               val body_code = handleBranch
                                   e
                                   (compileBranch (D.TLabel top) body)
                                   (handleExit next)
           in [D.ILabel top] @ body_code end)
      end
  and compileBranch next (S.SNil) = (next, [])
    | compileBranch next stm =
      let val label = L.newlabel "branch target"
      in (D.TLabel label, D.ILabel label :: compileStm next stm) end

  fun compileFunction (name, stm) =
      let val exit = L.newlabel "function exit"
          val code = compileStm (D.TLabel exit) stm
      in code @ [D.ILabel exit, D.IExit] end

end

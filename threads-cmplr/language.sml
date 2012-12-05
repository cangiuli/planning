structure C1Named =
struct

  type var = string

  datatype exp =
           EVar of var
         | ENum of int
         (* Only allowed in conditions for now. *)
         | ENot of var

  datatype stm =
           SNil
         | SAssign of var * exp
         | SInc of var
         | SDec of var
         (* mandatory else statement *)
         | SIf of exp * stm * stm
         | SWhile of exp * stm
         (* sequences two statement *)
         | SSeq of stm * stm
         | SFork of string * string

  type global = var * int
  type function = string * stm

  datatype should_finish = Finish | NotFinish
  datatype should_plan = Plan | NoPlan
  type goals = should_finish * should_plan * ((var * int) list)

  type program = global list * function list
end

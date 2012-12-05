CM.make "sources.cm";
open Toplevel C1Named;

(* A very basic looping program test. *)
compile "tests/loop.c1"
        (Finish, Plan, [("n", 0)])
        "../concurrency-domain/prob40-loop.pddl";


(* Tests of Dekker's algorithm. *)
compile "tests/dekker.c1"
        (Finish, Plan, [])
        "../concurrency-domain/prob41-dekker.pddl";
compile "tests/dekker-loop.c1"
        (NotFinish, NoPlan, [("num_in_section", 2)])
        "../concurrency-domain/prob42-dekker-loop.pddl";
compile "tests/dekker-loop.c1"
        (NotFinish, Plan, [("thread1_waiting", 1), ("thread2_iters", 4)])
        "../concurrency-domain/prob43-dekker-bw.pddl";

(* Test of a broken lock. *)
compile "tests/broken-lock.c1"
        (NotFinish, Plan, [("num_in_section", 2)])
        "../concurrency-domain/prob50-broken-mutex.pddl";

(* Tests of a mutex that mutually excludes but can livelock. *)
compile "tests/live-lock.c1"
        (NotFinish, NoPlan, [("num_in_section", 2)])
        "../concurrency-domain/prob60-livelock-mutex.pddl";
compile "tests/live-lock.c1"
        (NotFinish, Plan, [("thread1_waiting", 1), ("thread2_iters", 4)])
        "../concurrency-domain/prob61-livelock-bw.pddl";

(* Tests of Peterson's algorithm, which satisfies our bounded waiting *)
compile "tests/peterson-loop.c1"
        (NotFinish, NoPlan, [("num_in_section", 2)])
        "../concurrency-domain/prob70-peterson-mutex.pddl";
compile "tests/peterson-loop.c1"
        (NotFinish, NoPlan, [("thread1_waiting", 1), ("thread2_iters", 2)])
        "../concurrency-domain/prob71-peterson-bw.pddl";

module SL.Examples

open SepLogic.Heap
open SL.Effect

open FStar.Tactics

(*** command specific lemmas ***)

(*
 * these lemmas match on the VCs
 *)
let lemma_singleton_heap_rw (#a:Type0) (phi:memory -> memory -> a -> Type0) (r:ref a) (x:a)
  :Lemma (requires (phi (r |> x) emp x))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\
	                              (r |> x) == (m0 <*> m1) /\ (exists x. m0 == (r |> x) /\ phi m0 m1 x)))
  = ()

let lemma_rw (#a:Type0) (phi:memory -> memory -> a -> Type0) (r:ref a) (x:a) (m:memory)
  :Lemma (requires (defined ((r |> x) <*> m) /\ phi (r |> x) m x))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\
	                              ((r |> x) <*> m) == (m0 <*> m1) /\ (exists x. m0 == (r |> x) /\ phi m0 m1 x)))
  = ()

let lemma_bind (phi:memory -> memory -> memory -> memory -> Type0) (m m':memory)
  :Lemma (requires (exists m3 m4. defined (m3 <*> m4) /\ (m <*> m') == (m3 <*> m4) /\ phi (m <*> m') emp m3 m4))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ (m <*> m') == (m0 <*> m1) /\
	                              (exists (m3 m4:memory). defined (m3 <*> m4) /\ m0 == (m3 <*> m4) /\ phi m0 m1 m3 m4)))
  = ()

let lemma_singleton_heap_procedure (#a:Type0) (phi:memory -> memory -> a -> Type0)
		                   (r:ref a) (x:a)
  :Lemma (requires (phi (r |> x) emp x))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ (r |> x) == (m0 <*> m1) /\
	                              (m0 == (r |> x) /\ phi m0 m1 x)))
  = ()

let lemma_procedure (phi:memory -> memory -> memory -> memory -> Type0)
		    (m m':memory)
  :Lemma (requires (defined (m <*> m') /\ phi m m' m m'))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ (m <*> m') == (m0 <*> m1) /\
	                              (m0 == m /\ phi m m' m0 m1)))
  = ()

let lemma_pure_right (m m':memory) (phi:memory -> memory -> memory -> Type0)
  :Lemma (requires (defined (m <*> m') /\ phi m m' (m <*> m')))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ (m <*> m') == (m0 <*> m1) /\ phi m m' m1))
  = lemma_sep_comm (m <*> m') emp

let lemma_rewrite_sep_comm (m1 m2:memory) (phi:memory -> memory -> memory -> memory -> Type0)
  :Lemma (requires (exists (m3 m4:memory). defined (m3 <*> m4) /\ (m1 <*> m2) == (m3 <*> m4) /\ phi m1 m2 m3 m4))
         (ensures  (exists (m3 m4:memory). defined (m3 <*> m4) /\ (m2 <*> m1) == (m3 <*> m4) /\ phi m1 m2 m3 m4))
  = lemma_sep_comm m1 m2

let lemma_rewrite_sep_assoc1 (m1 m2 m3:memory) (phi:memory -> memory -> memory -> memory -> memory -> Type0)
  :Lemma (requires (exists (m4 m5:memory). defined (m4 <*> m5) /\ (m2 <*> (m1 <*> m3)) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
         (ensures  (exists (m4 m5:memory). defined (m4 <*> m5) /\ (m1 <*> (m2 <*> m3)) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
  = lemma_sep_comm m1 m2

let lemma_rewrite_sep_assoc2 (m1 m2 m3:memory) (phi:memory -> memory -> memory -> memory -> memory -> Type0)
  :Lemma (requires (exists (m4 m5:memory). defined (m4 <*> m5) /\ (m3 <*> (m1 <*> m2)) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
         (ensures  (exists (m4 m5:memory). defined (m4 <*> m5) /\ (m1 <*> (m2 <*> m3)) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
  = lemma_sep_comm m3 m1;
    lemma_sep_comm m3 m2

let lemma_rewrite_sep_assoc3 (m1 m2 m3:memory) (phi:memory -> memory -> memory -> memory -> memory -> Type0)
  :Lemma (requires (exists (m4 m5:memory). defined (m4 <*> m5) /\ ((m1 <*> m2) <*> m3) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
         (ensures  (exists (m4 m5:memory). defined (m4 <*> m5) /\ (m1 <*> (m2 <*> m3)) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
  = ()

let lemma_rewrite_sep_assoc4 (m1 m2 m3:memory) (phi:memory -> memory -> memory -> memory -> memory -> Type0)
  :Lemma (requires (exists (m4 m5:memory). defined (m4 <*> m5) /\ (m1 <*> (m2 <*> m3)) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
         (ensures  (exists (m4 m5:memory). defined (m4 <*> m5) /\ ((m1 <*> m2) <*> m3) == (m4 <*> m5) /\
	                     phi m1 m2 m3 m4 m5))
  = ()

private let rec apply_lemmas (l:list term) :Tac unit
  = match l with
    | []    -> fail "no command lemma matched the goal"
    | hd::tl -> or_else (fun () -> apply_lemma hd) (fun () -> apply_lemmas tl)

private let process_command () :Tac unit
  = apply_lemmas [`lemma_singleton_heap_rw;
                  `lemma_rw;
		  `lemma_bind;
		  `lemma_singleton_heap_procedure;
		  `lemma_procedure;
		  `lemma_pure_right]

let prelude () :Tac unit =
  let _ = forall_intros () in  //forall (p:post) (h:heap)
  let aux () =
    let h = implies_intro () in
    and_elim (pack (Tv_Var (fst (inspect_binder h))));
    clear h
  in
  ignore (repeat aux);  //(a /\ b) ==> c --> a ==> b ==> c, repeat to account for nested conjuncts
  ignore (repeat (fun _ -> let h = implies_intro () in
                        or_else (fun _ -> rewrite h) idtac))  //introduce the conjuncts into the context, but rewrite in the goal before doing that, specifically we want the initial heap expression to be inlined in the goal

private val split_lem : (#a:Type) -> (#b:Type) ->
                        squash a -> squash b -> Lemma (a /\ b)
let split_lem #a #b sa sb = ()


private let split' (#a #b: Type) (p_a: squash (a ==> b)) (p_b: squash a): Lemma (a /\ b) =
  ()

private let get_to_the_next_frame () :Tac unit =
  ignore (repeat (fun () -> apply_lemma (`split_lem); smt ()))

#reset-options "--using_facts_from '* -FStar.Tactics -FStar.Reflection' --max_fuel 0 --initial_fuel 0 --max_ifuel 0 --initial_ifuel 0 --use_two_phase_tc false --print_full_names --__temp_fast_implicits"


module P = PatternMatching

let rec iter (#a: Type) (f: a -> Tac unit) (l: list a): Tac unit =
  admit ();
  match l with
  | hd :: tl ->
     f hd;
     iter f tl
  | [] ->
     ()

(*
 * two commands
 *)
let write_read (r1 r2:ref int) (l1 l2:int) =
  (r1 := 2;
   !r2)

  <: STATE int (fun p m -> m == ((r1 |> l1) <*> (r2 |> l2)) /\ (defined m /\ p l2 ((r1 |> 2) <*> (r2 |> l2))))

  by (fun () ->
      prelude ();
      // Note: figure out why we shouldn't use forall_intros.
      // ignore (forall_intros ());
      // Simplify away all the existentials and
      // conjunctions, using the special split' lemma that allows us to steer
      // recursion into the right-hand side of conjunctions
      ignore (repeat (fun () ->
        norm [];
        match term_as_formula (cur_goal ()) with
        | Exists _ _ ->
            apply_lemma (`FStar.Classical.exists_intro);
            later ()
        | And _ _ ->
            apply_lemma (`split')
        | Implies _ _ ->
            ignore (implies_intro ())
        | _ ->
            fail ""
      ));
      let e = cur_env () in
      let bs = binders_of_env e in
      iter (fun b ->
        let h = type_of_binder b in
        match term_as_formula h with
        | Comp (Eq (Some t)) x y ->
            match inspect x, inspect y with
            | Tv_Uvar _ _, _ | _, Tv_Uvar _ _ ->
                ignore (pose h);
                trefl ()
      ) bs;
      dump "after initial discharging of all goals";
      fail "todo"
  )

(*
 * four commands
 *)
let swap (r1 r2:ref int) (x y:int)
  = (let x = !r1 in
     let y = !r2 in
     r1 := y;
     r2 := x)

     <: STATE unit (fun post m -> m == ((r1 |> x) <*> (r2 |> y)) /\ (defined m /\ post () ((r1 |> y) <*> (r2 |> x))))

     by (fun () -> prelude ();
       dump "swap1";
                process_command ();
		get_to_the_next_frame ();
		process_command ();
	        apply_lemma (`lemma_rewrite_sep_comm);
		process_command ();
	        get_to_the_next_frame ();
		process_command ();
	        apply_lemma (`lemma_rewrite_sep_comm);
		process_command ();
	        get_to_the_next_frame ();
	        apply_lemma (`lemma_rewrite_sep_comm);
		process_command ())

(*
 * three commands, the inline pure expressions don't count
 *)
let incr (r:ref int) (x:int)
  = (let y = !r in
     let z = y + 1 in
     r := z;
     !r)

     <: STATE int (fun post m -> m == (r |> x) /\ (defined m /\ post (x + 1) (r |> x + 1)))

     by (fun () -> prelude ();
  dump "incr1";
                process_command ();
		get_to_the_next_frame ();
		process_command ();
		get_to_the_next_frame ();
		process_command ();
		get_to_the_next_frame ();
		process_command ())

(*
 * 2 commands
 *)
let incr2 (r:ref int) (x:int)
  = (let y = incr r x in
     incr r y)

    <: STATE int (fun post m -> m == (r |> x) /\ (defined m /\ post (x + 2) (r |> x + 2)))

    by (fun () -> prelude ();
               process_command ();
	       get_to_the_next_frame ();
	       process_command ())

let rotate (r1 r2 r3:ref int) (x y z:int) =
  (swap r2 r3 y z;
   swap r1 r2 x z;
   let x = !r1 in
   x)
   
  <: STATE int (fun post m -> m == ((r1 |> x) <*> ((r2 |> y) <*> (r3 |> z))) /\
                         (defined m /\ post z ((r1 |> z) <*> ((r2 |> x) <*> (r3 |> y)))))

  by (fun () -> prelude ();
             apply_lemma (`lemma_rewrite_sep_comm);
             process_command ();
	     get_to_the_next_frame ();
	     process_command ();
	     apply_lemma (`lemma_rewrite_sep_comm);
	     apply_lemma (`lemma_rewrite_sep_assoc3);
	     process_command ();
	     get_to_the_next_frame ();
	     apply_lemma (`lemma_rewrite_sep_assoc4);
	     process_command ();
	     process_command ();
	     get_to_the_next_frame ();
	     process_command ())

let lemma_inline_in_patterns_two (psi1 psi2:Type) (m m':memory) (phi1 phi2: memory -> memory -> Type)
  :Lemma (requires (defined (m <*> m') /\ ((psi1 ==> phi1 (m <*> m') emp) /\ (psi2 ==> phi2 (m <*> m') emp))))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ (m <*> m') == (m0 <*> m1) /\
	                              ((psi1 ==> phi1 m0 m1) /\
				       (psi2 ==> phi2 m0 m1))))
  = ()

let lemma_frame_out_empty_right (phi:memory -> memory -> memory -> Type) (m:memory)
  :Lemma (requires (defined m /\ phi m m emp))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ m == (m0 <*> m1) /\ phi m m0 m1))
  = ()

let lemma_frame_out_empty_left (phi:memory -> memory -> memory -> Type) (m:memory)
  :Lemma (requires (defined m /\ phi m emp m))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\ m == (m0 <*> m1) /\ phi m m0 m1))
  = lemma_sep_comm m emp

let cond_test (r1 r2:ref int) (x:int) (b:bool)
  = (let y = !r1 in
     match b with
     | true  -> r1 := y + 1
     | false -> r2 := y + 2)

    <: STATE unit (fun p m -> m == ((r1 |> x) <*> (r2 |> x)) /\ (defined m /\ (b ==> p () ((r1 |> x + 1) <*> (r2 |> x))) /\
                                                                       (~ b ==> p () ((r1 |> x) <*> (r2 |> x + 2)))))

    by (fun () -> prelude ();
               apply_lemma (`lemma_rw);
	       get_to_the_next_frame ();
	       apply_lemma (`lemma_inline_in_patterns_two);
	       split (); smt ();
	       split ();
	       //goal 1
	       ignore (implies_intro ());
	       apply_lemma (`lemma_rw);
	       split (); smt (); split (); smt ();
	       apply_lemma (`lemma_pure_right);
	       smt ();
	       //goal 2
	       ignore (implies_intro ());
	       apply_lemma (`lemma_frame_out_empty_right);
	       split (); smt ();
	       split ();
	       //goal 2.1
	       ignore (implies_intro ());
	       apply_lemma (`lemma_rewrite_sep_comm);
	       apply_lemma (`lemma_rw);
	       split (); smt ();
	       split (); smt ();
	       apply_lemma (`lemma_frame_out_empty_left);
	       split (); smt (); split (); smt (); split (); smt ();
	       apply_lemma (`lemma_frame_out_empty_left);
	       smt ();
	       //goal 2.2
	       smt ())

#reset-options "--print_full_names --__no_positivity"

noeq type listptr' =
  | Null :listptr'
  | Cell :head:int -> tail:listptr -> listptr'

and listptr = ref listptr'

#reset-options "--print_full_names --__temp_fast_implicits"

let rec valid (p:listptr) (repr:list int) (m:memory) :Tot Type0 (decreases repr) =
  match repr with
  | []    -> m == (p |> Null)
  | hd::tl -> exists (tail:listptr) (m1:memory). defined ((p |> Cell hd tail) <*> m1) /\ m == ((p |> Cell hd tail) <*> m1) /\ valid tail tl m1

private let __exists_elim_as_forall
  (#a:Type) (#b:Type) (#p: a -> b -> Type) (#phi:Type)
  (_:(exists x y. p x y)) (_:(squash (forall (x:a) (y:b). p x y ==> phi)))
  :Lemma phi
  = ()

private let __elim_and (h:binder) :Tac unit
  = and_elim (pack (Tv_Var (bv_of_binder h)));
    clear h

private let __elim_exists (h:binder) :Tac unit
  = let t = `__exists_elim_as_forall in
    apply_lemma (mk_e_app t [pack (Tv_Var (bv_of_binder h))]);
    clear h;
    ignore (forall_intros ())

private let __implies_intros_with_processing_exists_and_and () :Tac unit
  = or_else (fun _ -> let h = implies_intro () in
                    or_else (fun _ -> __elim_and h)
		            (fun _ -> or_else (fun _ -> __elim_exists h)
			                   (fun _ -> or_else (fun _ -> rewrite h) idtac)))
            (fun _ -> fail "done")

#set-options "--z3rlimit 30 --use_two_phase_tc false"
let test0 (l:listptr)
  = (let x = !l in
     match x with
     | Cell hd tail -> (hd <: STATE int (fun p h -> p hd emp))
     | Null         -> (0 <: STATE int (fun p h -> p 0 emp)))

    <: STATE int (fun p m -> valid l [2; 3] m /\ (defined m /\ p 2 m))

    by (fun () ->
        let _ = forall_intros () in
	norm [delta_only ["SL.Examples.valid"]];
	ignore (repeat __implies_intros_with_processing_exists_and_and);
	apply_lemma (`lemma_rw);
	split (); smt (); split (); smt ();
	apply_lemma (`lemma_inline_in_patterns_two);
	split (); smt ();
	split ();
	//goal 1
	ignore (implies_intro ());
	apply_lemma (`lemma_pure_right);
	split (); smt (); ignore (forall_intros ());
	ignore (implies_intro ());
	split (); smt (); split (); smt ();
	apply_lemma (`lemma_pure_right);
	smt ();
	//goal 2
	ignore (implies_intro ());
	apply_lemma (`lemma_frame_out_empty_right);
	split (); smt ();
	split ();
	//goal 2.1
	ignore (implies_intro ());
	apply_lemma (`lemma_frame_out_empty_right);
	split (); smt ();
	split (); smt ();
	split (); smt ();
	apply_lemma (`lemma_frame_out_empty_right);
	split (); smt ();
	split (); smt ();
	split (); smt ();
	apply_lemma (`lemma_frame_out_empty_right);
	smt ();
	//goal 2.2
	smt ())

let lemma_rw_brancm2
  (#a:Type0) (#b:Type) (#c:Type) (phi:memory -> memory -> a -> b -> c -> Type0) (psi:b -> c -> Type)
  (r:ref a) (x:a) (m:memory)
  :Lemma (requires (defined ((r |> x) <*> m) /\ (forall (y:b) (z:c). phi (r |> x) m x y z)))
         (ensures  (exists (m0 m1:memory). defined (m0 <*> m1) /\
	                              ((r |> x) <*> m) == (m0 <*> m1) /\
				      (forall (y:b) (z:c). psi y z ==> (exists x. m0 == (r |> x) /\ phi m0 m1 x y z))))
  = ()

// let test1 (l:listptr)
//   = (let lv = !l in
//      match lv with
//      | Cell hd tail ->
//        l := Cell hd tail
//      | Null -> (() <: STATE unit (fun p h -> p () emp)))

//     <: STATE unit (fun p h -> valid l [2; 3] h /\ (defined h /\ p () h))

//     by (fun () ->
//         let _ = forall_intros () in
// 	norm [delta_only ["SL.Examples.valid"]];
// 	ignore (repeat __implies_intros_with_processing_exists_and_and);
// 	apply_lemma (`lemma_rw);
// 	split (); smt (); split (); smt ();
// 	apply_lemma (`lemma_inline_in_patterns_two);
// 	split (); smt ();
// 	split ();
// 	//goal 1
// 	ignore (implies_intro ());
// 	apply_lemma (`lemma_rw_brancm2);
// 	split (); smt ();
// 	ignore (forall_intros ()); split (); smt ();
//         dump "A")

// 	apply_lemma (`lemma_frame_out_empty_left);
// 	dump "A")
// 	smt ();
// 	//goal 2
// 	ignore (implies_intro ());
// 	apply_lemma (`lemma_frame_out_empty_right);
// 	split (); smt ();
// 	split ();
// 	//goal 2.1
// 	ignore (implies_intro ());
// 	apply_lemma (`lemma_frame_out_empty_right);
// 	split (); smt ();
// 	split (); smt ();
// 	split (); smt ();
// 	apply_lemma (`lemma_frame_out_empty_right);
// 	split (); smt ();
// 	split (); smt ();
// 	split (); smt ();
// 	apply_lemma (`lemma_frame_out_empty_right);
// 	smt ();
// 	//goal 2.2
// 	smt ();
//         dump "A")

// 	apply_lemma (`lemma_rw_rw);
// 	get_to_the_next_frame ();
// 	norm [delta_only ["SL.Examples.uu___is_Cell";
// 	                  "SL.Examples.uu___is_Null";
// 			  "SL.Examples.__proj__Cell__item__head";
// 			  "SL.Examples.__proj__Cell__item__head"]];
// 	norm [Prims.simplify];
// 	dump "A")



// // 	// let h = implies_intro () in
// // 	// __elim_and h;
// // 	// let h = implies_intro () in
// // 	// __elim_exists h;
// // 	// let h = implies_intro () in
// // 	// __elim_and h;
// // 	// let h = implies_intro () in
// // 	// __elim_and h;
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in
// // 	// let h = implies_intro () in
// // 	// __elim_exists h;
// // 	// let h = implies_intro () in
// // 	// __elim_and h;
// // 	// let h = implies_intro () in
// // 	// __elim_and h;
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in
// // 	// let h = implies_intro () in
// // 	// __elim_and h;
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in
// // 	// let _ = (let h = implies_intro () in or_else (fun _ -> rewrite h) idtac) in

// // // let foo (p:int -> int -> Type) (q:int -> int -> int -> int -> Type) (r:Type)
// // //   = assert_by_tactic ((exists x1 x2. (p x1 x2 /\ (exists x3 x4. q x1 x2 x3 x4))) ==> r)
// // //     (fun () -> 
// // //      let h  = implies_intro () in
// // //      let ae = `__exists_elim_as_forall in
// // //      apply_lemma (mk_e_app ae [pack (Tv_Var (bv_of_binder h))]);
// // //      clear h;
// // //      let _ = forall_intros () in
// // //      let h = implies_intro () in
// // //      and_elim (pack (Tv_Var (bv_of_binder h)));
// // //      clear h;
// // //      let _ = implies_intro () in
// // //      let h  = implies_intro () in
// // //      let ae = `__exists_elim_as_forall in
// // //      apply_lemma (mk_e_app ae [pack (Tv_Var (bv_of_binder h))]);
// // //      clear h;
// // //      let _ = forall_intros () in
// // //      let h = implies_intro () in
// // //      dump "A")

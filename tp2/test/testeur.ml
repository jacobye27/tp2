(* -------------------------------------------------------------------------- *)
(* ----------------------- TP1 - IFT-3000 - Hiver 2024 ---------------------- *)
(* -------------------------------------------------------------------------- *)
(** Fichier permettant de tester les fonctions implantées du TP               *)
(* -------------------------------------------------------------------------- *)

open GcpLib
open Gcp
open Cours
open Programmes
open Tp2

(******************************************************************************)
(* JEUX DE DONNÉES
   Un jeu de données est composé d'un tuple comprenant les éléments suivants:
   - le nom de la fonction à tester;
   - une fonction qui permet de préciser comment le testeur doit agir avec les
     données et le résultat attendu pour chaque test;
   - une liste de tuples comprenant chaque donnée à tester, le résultat attendu,
     une chaine de caractères précisant le code testé (fonction et arguments);
   - en option, une même liste de tuples qui concernent les cas qui devraient
     soulever une exception, précédée par le code à utiliser pour lancer le test
     et donc, en théorie, provoquer une exception.
*)
(******************************************************************************)

(* -------------------------------------------------------------------------- *)
let jeu_ret_lnc_pre =
  let ret_lnc_pre' = ret_lnc_pre bcours in
  let cours_c_ift, cours_mp_jv, cours_b_glo =
    (cours_pgm c_ift, cours_pgm mp_jv, cours_pgm b_glo)
  in
  ( "ret_lnc_pre",
    (fun (cours_pgm, nc) res -> eql (ret_lnc_pre' (cours_pgm, nc)) res),
    [
      (([], "IFT-3000"), [], {| ret_lnc_pre bcours [] "IFT-3000" |});
      ( (cours_c_ift, "IFT-3000"),
        [ "GIF-1003"; "IFT-1006"; "IFT-2008"; "GLO-2100" ],
        {| ret_lnc_pre bcours (cours_pgm c_ift) "IFT-3000" |} );
      ( (cours_b_glo, "IFT-3000"),
        [ "GIF-1003"; "GLO-2100" ],
        {| ret_lnc_pre bcours (cours_pgm b_glo) "IFT-3000" |} );
      ( (cours_mp_jv, "GLO-4002"),
        [],
        {| ret_lnc_pre bcours (cours_pgm mp_jv) "GLO-4002" |} );
    ],
    (* ---- Cas devant soulever une exception! ---- *)
    Some
      ( (fun nc -> ret_lnc_pre' (cours_c_ift, nc)),
        [ ("XYZ-3000", {|ret_lnc_pre bcours (cours_pgm c_ift) "XYZ-3000"|}) ] )
  )

(* -------------------------------------------------------------------------- *)
let jeu_ret_lnc_post =
  let ret_lnc_post' = ret_lnc_post bcours in
  let cours_c_ift, cours_b_ift = (cours_pgm c_ift, cours_pgm b_ift) in
  ( "ret_lnc_post",
    (fun (cours_pgm, nc) res -> eql (ret_lnc_post' (cours_pgm, nc)) res),
    [
      (([], "IFT-3000"), [], {| ret_lnc_post bcours [] "IFT-3000" |});
      ( (cours_b_ift, "IFT-3000"),
        [ "GLO-4010" ],
        {| ret_lnc_post bcours (cours_pgm b_ift) "IFT-3000" |} );
      ( (cours_c_ift, "IFT-3000"),
        [],
        {| ret_lnc_post bcours (cours_pgm c_ift) "IFT-3000" |} );
      ( (cours_c_ift, "IFT-1004"),
        [
          "GIF-1001";
          "GIF-1003";
          "IFT-1006";
          "IFT-2004";
          "GLO-2005";
          "SIO-2102";
          "SIO-2104";
        ],
        {| ret_lnc_post bcours (cours_pgm c_ift) "IFT-1004" |} );
      ( (cours_b_ift, "IFT-1004"),
        [
          "BIF-1001";
          "GIF-1001";
          "GIF-1003";
          "IFT-1006";
          "IFT-2003";
          "IFT-2004";
          "GLO-2005";
          "SIO-2100";
          "SIO-2102";
          "SIO-2104";
          "SIO-2105";
          "SIO-2107";
          "STT-2200";
          "GLO-4001";
          "BIF-4007";
          "IFT-4030";
          "IFT-4100";
          "GIF-4105";
        ],
        {| ret_lnc_post bcours (cours_pgm b_ift) "IFT-1004" |} );
    ],
    (* ---- Cas devant soulever une exception! ---- *)
    Some
      ( (fun nc -> ret_lnc_post' (cours_c_ift, nc)),
        [ ("XYZ-3000", {|ret_lnc_post bcours (cours_pgm c_ift) "XYZ-3000"|}) ]
      ) )

(* -------------------------------------------------------------------------- *)
let jeu_graphe_pre_post_cours1 =
  ( "graphe_pre_post_cours",
    (fun (lnc, nc) res ->
      let res' = graphe_pre_cours bcours (lnc, nc) in
      eql res res'),
    [
      ( (cours_pgm b_ift, "IFT-3000"),
        [
          Noeud ("GIF1003", [ "GIF-1003"; "IFT-1006" ]);
          Noeud ("GLO2100", [ "GLO-2100"; "IFT-2008" ]);
          Arete ("GIF1003", "IFT3000");
          Arete ("GLO2100", "IFT3000");
          Noeud ("IFT1004", [ "IFT-1004" ]);
          Arete ("IFT1004", "GIF1003");
          Arete ("GIF1003", "GLO2100");
        ],
        {|graphe_pre_cours bcours (cours_pgm b_ift, "IFT-3000")|} );
      ( (cours_pgm b_ift, "IFT-2003"),
        [
          Noeud ("IFT1000", [ "IFT-1000" ]);
          Noeud ("MAT1919", [ "MAT-1919" ]);
          Noeud ("IFT1004", [ "IFT-1004" ]);
          Arete ("IFT1000", "IFT2003");
          Arete ("MAT1919", "IFT2003");
          Arete ("IFT1004", "IFT2003");
          Arete ("MAT1919", "IFT1000");
        ],
        {|graphe_pre_cours bcours (cours_pgm b_ift, "IFT-2003")|} );
      ( (cours_pgm b_ift, "IFT-2103"),
        [
          Noeud ("GIF1003", [ "GIF-1003"; "IFT-1006" ]);
          Noeud ("IFT3100", [ "IFT-3100" ]);
          Arete ("GIF1003", "IFT2103");
          Arete ("IFT3100", "IFT2103");
          Noeud ("IFT1004", [ "IFT-1004" ]);
          Arete ("IFT1004", "GIF1003");
          Arete ("GIF1003", "IFT3100");
        ],
        {|graphe_pre_cours bcours (cours_pgm b_ift, "IFT-2103")|} );
      ( (cours_pgm mp_base, "IFT-1006"),
        [ Noeud ("IFT1004", [ "IFT-1004" ]); Arete ("IFT1004", "IFT1006") ],
        {|graphe_pre_cours bcours (cours_pgm mp_base, "IFT-1006")|} );
      ( (cours_pgm mp_base, "GLO-2100"),
        [
          Noeud ("GIF1003", [ "GIF-1003"; "IFT-1006" ]);
          Arete ("GIF1003", "GLO2100");
          Noeud ("IFT1004", [ "IFT-1004" ]);
          Arete ("IFT1004", "GIF1003");
        ],
        {|graphe_pre_cours bcours (cours_pgm mp_base, "GLO-2100")|} );
      ( (bcours |> List.map fst, "GLO-2100"),
        [
          Noeud ("GIF1003", [ "GIF-1003"; "IFT-1006" ]);
          Arete ("GIF1003", "GLO2100");
          Noeud ("GLO1901", [ "GLO-1901"; "IFT-1004" ]);
          Arete ("GLO1901", "GIF1003");
        ],
        {|graphe_pre_cours bcours (bcours |> List.map fst, "GLO-2100")|} );
    ],
    (* ---- Cas devant soulever une exception! ---- *)
    Some
      ( (fun (lnc, nc) -> graphe_pre_cours bcours (lnc, nc)),
        [
          ( (cours_pgm c_ift, "XYZ-3000"),
            {|graphe_pre_cours bcours (cours_pgm c_ift, "XYZ-3000")|} );
        ] ) )

let jeu_graphe_pre_post_cours2 =
  ( "graphe_pre_post_cours",
    (fun (lnc, nc) res ->
      let res' = graphe_post_cours bcours (lnc, nc) in
      eql res res'),
    [
      ( (cours_pgm b_ift, "IFT-3000"),
        [ Noeud ("GLO4010", [ "GLO-4010" ]); Arete ("IFT3000", "GLO4010") ],
        {|graphe_post_cours bcours (cours_pgm b_ift, "IFT-3000")|} );
      ( (cours_pgm b_ift, "IFT-2003"),
        [],
        {|graphe_post_cours bcours (cours_pgm b_ift, "IFT-2003")|} );
      ( (cours_pgm b_ift, "IFT-2103"),
        [ Noeud ("IFT3113", [ "IFT-3113" ]); Arete ("IFT2103", "IFT3113") ],
        {|graphe_post_cours bcours (cours_pgm b_ift, "IFT-2103")|} );
      ( (cours_pgm mp_base, "IFT-1006"),
        [
          Noeud ("GLO2004", [ "GLO-2004"; "IFT-2007" ]);
          Noeud ("GLO2100", [ "GLO-2100"; "IFT-2008" ]);
          Noeud ("IFT2103", [ "IFT-2103" ]);
          Noeud ("IFT3000", [ "IFT-3000" ]);
          Noeud ("IFT3100", [ "IFT-3100" ]);
          Arete ("IFT1006", "GLO2004");
          Arete ("IFT1006", "GLO2100");
          Arete ("IFT1006", "IFT2103");
          Arete ("IFT1006", "IFT3000");
          Arete ("IFT1006", "IFT3100");
          Arete ("GLO2100", "IFT3000");
          Noeud ("IFT2001", [ "IFT-2001" ]);
          Arete ("GLO2100", "IFT2001");
          Arete ("IFT3100", "IFT2103");
        ],
        {|graphe_post_cours bcours (cours_pgm mp_base, "IFT-1006")|} );
      ( (cours_pgm mp_base, "GLO-2100"),
        [
          Noeud ("IFT2001", [ "IFT-2001" ]);
          Noeud ("IFT3000", [ "IFT-3000" ]);
          Arete ("GLO2100", "IFT2001");
          Arete ("GLO2100", "IFT3000");
        ],
        {|graphe_post_cours bcours (cours_pgm mp_base, "GLO-2100")|} );
      ( (bcours |> List.map fst, "GLO-2100"),
        [
          Noeud ("GLO2001", [ "GLO-2001"; "IFT-2001" ]);
          Noeud ("IFT3000", [ "IFT-3000" ]);
          Noeud ("IFT3001", [ "IFT-3001" ]);
          Noeud ("GLO3100", [ "GLO-3100" ]);
          Noeud ("GLO4009", [ "GLO-4009" ]);
          Noeud ("IFT4021", [ "IFT-4021" ]);
          Noeud ("IFT4022", [ "IFT-4022" ]);
          Noeud ("GLO4027", [ "GLO-4027" ]);
          Noeud ("IFT4029", [ "IFT-4029" ]);
          Noeud ("IFT4102", [ "IFT-4102" ]);
          Noeud ("GIF4104", [ "GIF-4104" ]);
          Noeud ("IFT4201", [ "IFT-4201" ]);
          Arete ("GLO2100", "GLO2001");
          Arete ("GLO2100", "IFT3000");
          Arete ("GLO2100", "IFT3001");
          Arete ("GLO2100", "GLO3100");
          Arete ("GLO2100", "GLO4009");
          Arete ("GLO2100", "IFT4021");
          Arete ("GLO2100", "IFT4022");
          Arete ("GLO2100", "GLO4027");
          Arete ("GLO2100", "IFT4029");
          Arete ("GLO2100", "IFT4102");
          Arete ("GLO2100", "GIF4104");
          Arete ("GLO2100", "IFT4201");
          Noeud ("GIF3000", [ "GIF-3000" ]);
          Noeud ("GIF3004", [ "GIF-3004" ]);
          Noeud ("GLO4008", [ "GLO-4008" ]);
          Arete ("GLO2001", "GIF3000");
          Arete ("GLO2001", "GIF3004");
          Arete ("GLO2001", "GLO4008");
          Noeud ("GLO4010", [ "GLO-4010" ]);
          Arete ("IFT3000", "GLO4010");
          Noeud ("IFT4001", [ "IFT-4001" ]);
          Noeud ("IFT4003", [ "IFT-4003" ]);
          Arete ("IFT3001", "IFT4001");
          Arete ("IFT3001", "IFT4003");
          Arete ("IFT4102", "IFT4201");
          Noeud ("GLO4030", [ "GLO-4030" ]);
          Arete ("IFT4102", "GLO4030");
        ],
        {|graphe_post_cours bcours (bcours |> List.map fst, "GLO-2100")|} );
    ],
    (* ---- Cas devant soulever une exception! ---- *)
    Some
      ( (fun (lnc, nc) -> graphe_post_cours bcours (lnc, nc)),
        [
          ( (cours_pgm c_ift, "XYZ-3000"),
            {|graphe_post_cours bcours (cours_pgm c_ift, "XYZ-3000")|} );
        ] ) )

(* -------------------------------------------------------------------------- *)
let jeu_graphe_pgm =
  let graphe_pgm' = graphe_pgm bcours in
  ( "graphe_pgm",
    (fun pgm res -> eql (graphe_pgm' pgm) res),
    [
      ( mp_web,
        [
          Noeud ("IFT1004", [ "IFT-1004" ]);
          Noeud ("GIF1003", [ "GIF-1003"; "IFT-1006" ]);
          Noeud ("GLO2005", [ "GLO-2005"; "IFT-2004" ]);
          Arete ("IFT1004", "GIF1003");
          Arete ("IFT1004", "GLO2005");
          Noeud ("GLO2004", [ "GLO-2004"; "IFT-2007" ]);
          Arete ("GIF1003", "GLO2004");
          Noeud ("GLO3102", [ "GLO-3102" ]);
          Arete ("GLO2004", "GLO3102");
          Noeud ("GLO3112", [ "GLO-3112" ]);
          Arete ("GLO3102", "GLO3112");
          Arete ("GLO2005", "GLO3112");
        ],
        {| graphe_pgm mp_web |} );
      ( c_ift,
        [
          Noeud ("IFT1004", [ "IFT-1004" ]);
          Noeud ("GLO3101", [ "GLO-3101" ]);
          Noeud ("GLO4000", [ "GLO-4000" ]);
          Noeud ("IFT1003", [ "IFT-1003" ]);
          Noeud ("IFT1700", [ "IFT-1700" ]);
          Noeud ("GIF1001", [ "GIF-1001" ]);
          Noeud ("GIF1003", [ "GIF-1003"; "IFT-1006" ]);
          Noeud ("GLO2005", [ "GLO-2005"; "IFT-2004" ]);
          Noeud ("SIO2102", [ "SIO-2102" ]);
          Noeud ("SIO2104", [ "SIO-2104" ]);
          Arete ("IFT1004", "GIF1001");
          Arete ("IFT1004", "GIF1003");
          Arete ("IFT1004", "GLO2005");
          Arete ("IFT1004", "SIO2102");
          Arete ("IFT1004", "SIO2104");
          Noeud ("GLO2000", [ "GLO-2000"; "IFT-2006" ]);
          Noeud ("GLO2001", [ "GLO-2001"; "IFT-2001" ]);
          Noeud ("IFT3002", [ "IFT-3002" ]);
          Arete ("GIF1001", "GLO2000");
          Arete ("GIF1001", "GLO2001");
          Arete ("GIF1001", "IFT3002");
          Noeud ("IFT2101", [ "IFT-2101" ]);
          Noeud ("IFT3201", [ "IFT-3201" ]);
          Noeud ("GLO4008", [ "GLO-4008" ]);
          Noeud ("IFT4029", [ "IFT-4029" ]);
          Arete ("GLO2000", "IFT2101");
          Arete ("GLO2000", "IFT3201");
          Arete ("GLO2000", "GLO4008");
          Arete ("GLO2000", "IFT4029");
          Arete ("GLO2001", "GLO4008");
          Noeud ("GLO2004", [ "GLO-2004"; "IFT-2007" ]);
          Noeud ("GLO2100", [ "GLO-2100"; "IFT-2008" ]);
          Noeud ("IFT2103", [ "IFT-2103" ]);
          Noeud ("IFT3000", [ "IFT-3000" ]);
          Noeud ("IFT3100", [ "IFT-3100" ]);
          Arete ("GIF1003", "GLO2004");
          Arete ("GIF1003", "GLO2100");
          Arete ("GIF1003", "IFT2103");
          Arete ("GIF1003", "IFT3000");
          Arete ("GIF1003", "IFT3100");
          Noeud ("GLO2003", [ "GLO-2003" ]);
          Noeud ("GLO3102", [ "GLO-3102" ]);
          Noeud ("GLO4002", [ "GLO-4002" ]);
          Arete ("GLO2004", "GLO2003");
          Arete ("GLO2004", "GLO3102");
          Arete ("GLO2004", "GLO4002");
          Arete ("GLO2003", "GLO4002");
          Noeud ("IFT2102", [ "IFT-2102" ]);
          Arete ("GLO2003", "IFT2102");
          Noeud ("GLO3112", [ "GLO-3112" ]);
          Noeud ("GLO3202", [ "GLO-3202" ]);
          Arete ("GLO3102", "GLO3112");
          Arete ("GLO3102", "GLO3202");
          Arete ("GLO4002", "GLO4008");
          Noeud ("GLO4003", [ "GLO-4003" ]);
          Arete ("GLO4002", "GLO4003");
          Arete ("GLO2100", "GLO2001");
          Arete ("GLO2100", "IFT3000");
          Arete ("GLO2100", "IFT4029");
          Noeud ("GLO4009", [ "GLO-4009" ]);
          Noeud ("GLO4027", [ "GLO-4027" ]);
          Noeud ("GIF4104", [ "GIF-4104" ]);
          Arete ("GLO2100", "GLO4009");
          Arete ("GLO2100", "GLO4027");
          Arete ("GLO2100", "GIF4104");
          Noeud ("IFT3113", [ "IFT-3113" ]);
          Arete ("IFT2103", "IFT3113");
          Arete ("IFT3100", "IFT2103");
          Arete ("GLO2005", "GLO3112");
          Arete ("GLO2005", "GLO4027");
          Noeud ("GLO4035", [ "GLO-4035" ]);
          Arete ("GLO2005", "GLO4035");
          Arete ("IFT1003", "IFT2102");
        ],
        {| graphe_pgm c_ift |} );
    ],
    (* ---- Cas devant soulever une exception! ---- *)
    None )

(* -------------------------------------------------------------------------- *)
let jeu_ordonner_id_cours_par_session =
  ( "ordonner_id_cours_par_session",
    (fun pgm res ->
      let res' = ordonner_id_cours_par_session (graphe_pgm bcours pgm) in
      List.for_all2 (fun l l' -> eql l l') res res'),
    [
      ( c_ift,
        [
          [ "IFT1700"; "IFT1003"; "GLO4000"; "GLO3101"; "IFT1004" ];
          [ "SIO2104"; "SIO2102"; "GLO2005"; "GIF1003"; "GIF1001" ];
          [ "GLO4035"; "IFT3100"; "GLO2100"; "GLO2004"; "IFT3002"; "GLO2000" ];
          [
            "GIF4104";
            "GLO4027";
            "GLO4009";
            "GLO3102";
            "GLO2003";
            "IFT3000";
            "IFT2103";
            "IFT4029";
            "IFT3201";
            "IFT2101";
            "GLO2001";
          ];
          [ "IFT3113"; "GLO3202"; "GLO3112"; "IFT2102"; "GLO4002" ];
          [ "GLO4003"; "GLO4008" ];
        ],
        {| ordonner_id_cours_par_session (graphe_pgm bcours c_ift) |} );
      ( mp_base,
        [
          [ "IFT1700"; "IFT1003"; "IFT1004" ];
          [ "IFT2004"; "GIF1003"; "GIF1001" ];
          [ "IFT3100"; "GLO2100"; "GLO2004"; "IFT3002"; "IFT2006" ];
          [ "IFT3000"; "IFT2103"; "IFT2001" ];
        ],
        {| ordonner_id_cours_par_session (graphe_pgm bcours mp_base) |} );
    ],
    (* ---- Cas devant soulever une exception! ---- *)
    None )

(*****************************************************************************)
(* ------------------------------------------------------------------------- *)
(* -- Test générique--------------------------------------------------------
   La fonction testg a comme signature (donc, extrêmement générique):
      'a * ('b -> 'c -> bool) * ('b * 'c * string) list *
      (('d -> 'e) * ('d * string) list) option ->
      'a * bool * string List.t * bool * bool
   Elle prend comme argument le nom de la fonction à tester, la fonction à
   utiliser pour comparer le résultat obtenu avec chaque jeu de test et le
   résultat attendu, un jeu de données (comme décrit au début du fichier), et
   éventuellement celui concernant les cas d'exceptions, et retourne un 5-uplet
   formé du nom de la fonction, du résultat obtenu pour le test en question,
   des commentaires éventuels issus du test, d'un booléen qui précise si la
   fonction testée est non implantée et d'un booléen qui précise si une
   exception a été soulevée durant le test de la fonction en question.
*)
(* ------------------------------------------------------------------------- *)

(* La fonction suivante permet de tester n'importe quelle autre fonction
   en prenant soin de limiter le temps d'exécution à un #sec fixé (par défaut,
   3 sec.; on peut évidemment ajuster cette valeur).
   (version fonctionnelle que sous Linux/Unix (donc, sous WSL et MacOS))

   À cause de l'utilisation du module Unix, il faut charger la librairie au
   préalable:
   - (en mode interpréteur) #require "unix";;
   - (en mode compilation) ... -package unix ...
   Avec l'outil «dune», il faut simplement mentionner le nom de cette librairie
   dans le fichier «dune» (voir celui qui est dans le présent dossier).
*)
exception Timeout

let call_with_timeout ?(time_in_seconds = 3) f =
  Sys.set_signal Sys.sigalrm (Sys.Signal_handle (fun _ -> raise Timeout));
  try
    ignore (Unix.alarm time_in_seconds);
    let result = f () in
    ignore (Unix.alarm 0);
    result
  with exn ->
    ignore (Unix.alarm 0);
    raise exn

let testg (nom_f, f, jeu_donnees, jeu_donnees_exception_op) =
  let comment_l = ref [] in
  let ok = ref true in
  let excep = ref false in

  try
    List.iter
      (fun (p, res, cas_test) ->
        match call_with_timeout (fun () -> f p res) with
        | true -> ()
        | false ->
            ok := false;
            comment_l := !comment_l @ [ cas_test ^ " --> incorrect!" ]
        | exception Non_Implante s ->
            ok := false;
            raise (Non_Implante s)
        | exception e ->
            ok := false;
            excep := true;
            comment_l :=
              !comment_l
              @ [
                  cas_test ^ " - Exception soulevée: «" ^ Printexc.to_string e
                  ^ "»";
                ])
      jeu_donnees;
    (match jeu_donnees_exception_op with
    | None -> ()
    | Some (f', jeu_donnees_exception) ->
        List.iter
          (fun (p, cas_test) ->
            try
              ignore (call_with_timeout (fun () -> f' p));
              ok := false;
              comment_l :=
                !comment_l
                @ [ cas_test ^ " --> incorrect! Devrait soulever exception!" ]
            with
            | Failure _ -> ()
            | Timeout ->
                ok := false;
                excep := true;
                comment_l :=
                  !comment_l @ [ cas_test ^ " - Exception soulevée: «Timeout»" ]
            | e ->
                ok := false;
                excep := true;
                comment_l :=
                  !comment_l
                  @ [
                      cas_test
                      ^ " --> incorrect! Devrait soulever exception «Failure»"
                      ^ " et non «" ^ Printexc.to_string e ^ "»";
                    ])
          jeu_donnees_exception);
    (nom_f, !ok, !comment_l, false, !excep)
  with Non_Implante _ ->
    (nom_f, !ok, !comment_l @ [ "Fonction non implantée!" ], true, !excep)

(* -------------------------------------------------------------------------- *)
(* -- TESTE TOUT ------------------------------------------------------------
   La fonction test a comme signature:
     unit -> (string * bool * string list * bool * bool) list
   Elle effectue les n tests permettant de tester chacune des fonctions du Tp,
   et retourne une liste de 5-uplet:
   - nom de la fonction testée
   - un booléen qui précise le résultat du test pour cette fonction
   - les commentaires éventuels issus des tests
   - un booléen qui précise si la fonction est non implantée
   - un booléen qui précise si une exception a été soulevée
*)
(* -------------------------------------------------------------------------- *)
let tests () =
  [
    testg jeu_ret_lnc_pre;
    testg jeu_ret_lnc_post;
    (let nom_f, ok, comment, b1, b2 = testg jeu_graphe_pre_post_cours1
     and _, ok', comment', b1', b2' = testg jeu_graphe_pre_post_cours2 in
     (nom_f, ok && ok', comment @ comment', b1 && b1', b2 && b2'));
    testg jeu_graphe_pgm;
    testg jeu_ordonner_id_cours_par_session;
  ]

(* -------------------------------------------------------------------------- *)
(* -- CORRIGE ---------------------------------------------------------------
   Le type de cette fonction est unit -> unit
   Elle appelle la fonction «tests», récupère les résultats des tests et
   affiche seulement le nom de chaque fonction testée, le résultat obtenu et
   les éventuels commentaires.
*)
(* -------------------------------------------------------------------------- *)
let corrige () =
  print_endline "Resultats:";
  print_endline "----------\n";
  List.iter
    (fun (nom_f, ok, comment, _, _) ->
      Printf.printf "%s : %s\n" nom_f (if ok then "OK" else "");
      List.iter (fun c -> print_endline ("\t" ^ c)) comment)
    (tests ())
;;

corrige ()

(* Avec version du corrigé:

    dune runtest

    Resultats:
    ----------

    ret_lnc_pre : OK
    ret_lnc_post : OK
    graphe_pre_post_cours : OK
    graphe_pgm : OK
    ordonner_id_cours_par_session : OK

   Avec version remise et donc non complétée:

    dune runtest

    Resultats:
    ----------

    ret_lnc_pre :
             Fonction non implantée!
    ret_lnc_post :
             Fonction non implantée!
    graphe_pre_post_cours :
             Fonction non implantée!
    graphe_pgm :
             Fonction non implantée!
    ordonner_id_cours_par_session :
             Fonction non implantée!
*)

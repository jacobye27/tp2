open GcpLib
open Gcp
open Tp2
open List
open Printf

(* ************************************************************************* *)
(* * Fonctions utiles ****************************************************** *)
(* ************************************************************************* *)
let l_sess_str1 = [ (Aut, "A"); (Hiv, "H"); (Ete, "E"); (Annee, "Année") ]
let sess2str1 session = assoc session l_sess_str1

let ob_ou_op lnc_ob lnc =
  if exists (fun nc' -> mem nc' lnc_ob) lnc then OB else OP

(* ************************************************************************* *)
(* * Fonctions et constante pour génération du PDF ************************* *)
(* ************************************************************************* *)
(* rankdir: "TB", "LR", "BT", "RL" *)
let header ?(dir = "LR") ?(size = 10) ?(titre = "") () =
  if titre = "" then
    Printf.sprintf
      "digraph cours {\n\
       \tcharset=\"UTF-8\"\n\
       \trankdir=%s;\n\
       \tnode [style=filled, fontsize=%d, shape=record];\n\n"
      dir size
  else
    Printf.sprintf
      "digraph cours {\n\
       \tcharset=\"UTF-8\"\n\
       \trankdir=%s;\n\
       \tlabel=\"%s\";\n\n\
       \tlabelloc=t;\n\
       \tfontsize=%d;\n\
       \tfontcolor=blue;\n\n\
       \tnode [style=filled, fontsize=%d shape=record];\n\n"
      dir titre (size * 2) size

let footer = "}"

(* ************************************************************************* *)
(* * Fonctions propres à la génération du graphe de dépendances en format gv *)
(* ************************************************************************* *)
(* Fonctions auxiliaires --------------------------------------------------- *)
let graphe_coherent elements =
  for_all
    (function
      | Noeud _ -> true
      | Arete (id1, id2) ->
          exists
            (function Noeud (id, _) -> id = id1 | Arete _ -> false)
            elements
          && exists
               (function Noeud (id, _) -> id = id2 | Arete _ -> false)
               elements)
    elements

let spr_ordre (ordre_sessions : string list list) : string =
  let spr = Printf.sprintf in
  let n = length ordre_sessions in
  let init =
    "node [shape=plaintext, style=\"\", fontsize=16, fontcolor=\"firebrick\"];\n"
  in
  let tab_sess =
    Array.init n (fun i ->
        (spr "sess%d" (i + 1), spr "[label=\"Session #%d\"];\n" (i + 1)))
  in
  let sess_lst, sess1 =
    Array.fold_left
      (fun (acc, acc1) (s1, s2) -> (acc @ [ s1 ], acc1 ^ s1 ^ " " ^ s2))
      ([], "") tab_sess
  in
  let sess2 =
    if length sess_lst <= 1 then ""
    else
      fold_left (fun acc s -> acc ^ " -> " ^ s) (hd sess_lst) (tl sess_lst)
      ^ " [style=invis];\n"
  in
  let rank =
    fold_left2
      (fun acc idl s ->
        let ids =
          fold_left (fun acc id -> acc ^ " " ^ "\"" ^ id ^ "\"") "" idl
        in
        acc ^ spr "{rank=same; \"%s\"; {node [style=invis] %s}}\n" s ids)
      "" ordre_sessions sess_lst
  in
  init ^ "\n" ^ sess1 ^ "\n" ^ sess2 ^ rank

let spr_cours ?(other_attr = "") (bcours : cours list) (id : string)
    (lnc : num_cours list) (tc : type_cours) : string =
  let nc2str nc offre = Printf.sprintf "%s\\n%s" nc offre in
  let off2str (offre : (session * fe) list) : string =
    let offre =
      fold_left (fun acc (s, _) -> if mem s acc then acc else s :: acc) [] offre
    in
    let offre =
      if mem Annee offre then [ Aut; Hiv; Ete ]
      else
        sort
          (fun s1 s2 ->
            match (s1, s2) with
            | Aut, _ -> -1
            | Hiv, Aut -> 1
            | Hiv, Ete -> -1
            | _ -> 1)
          offre
    in
    let rec aux offre =
      match offre with
      | [] -> ""
      | [ s ] -> sess2str1 s
      | s :: r -> sess2str1 s ^ aux r
    in
    aux offre
  in
  let loffre =
    map
      (fun nc ->
        let { offre; _ } = ret_descr bcours nc in
        offre)
      lnc
  in
  let loff = map (fun offre -> "(" ^ off2str offre ^ ")") loffre in
  let color = match tc with OB -> "bisque" | _ -> "white" in
  match lnc with
  | [] -> ""
  | [ nc ] ->
      Printf.sprintf "%s [label=\"%s\" fillcolor=\"%s\" %s]\n" id
        (nc2str nc (hd loff))
        color other_attr
  | nc :: reste ->
      let reste' =
        fold_left2
          (fun acc nc offre -> acc ^ "|" ^ nc2str nc offre)
          "" reste (tl loff)
      in
      Printf.sprintf "%s [label=\"%s%s\" fillcolor=\"%s\" %s]\n" id
        (nc2str nc (hd loff))
        reste' color other_attr

(* Fonction pour graphed dépendances cours----------------------------------- *)
let getGv ?(dir = "LR") ?(size = 10) ?(titre = "") (bcours : cours list)
    (pgm : string) (nc : num_cours) : string array =
  try
    let nc = String.(trim @@ uppercase_ascii nc) in
    let lcp, lc_ob =
      if pgm = "aucun" then (bcours |> map fst, [])
      else
        let p = assoc pgm GcpLib.Programmes.l_pgms in
        let lc_ob = cours_pgm_par_type p OB in
        let lc_op = cours_pgm_par_type p OP in
        (lc_op ++ lc_ob, lc_ob)
    in
    if not (mem nc lcp) then [| "vide"; "" |]
    else
      let id_nc = id nc in
      let lres = graphe_cours bcours (lcp, nc) in
      let spr = spr_cours bcours in
      let nodep =
        spr_cours bcours id_nc [ nc ] (ob_ou_op lc_ob [ nc ])
          ~other_attr:"fontcolor=blue"
      in
      let gv =
        fold_left
          (fun acc r ->
            match r with
            | Noeud (id, lnc) -> acc ^ spr id lnc (ob_ou_op lc_ob lnc)
            | Arete (id1, id2) -> acc ^ Printf.sprintf "%s -> %s\n" id1 id2)
          "" lres
      in
      [| header ~dir ~size ~titre () ^ (nodep ^ gv) ^ footer; "" |]
  with
  | Non_Implante s -> [| ""; s |]
  | Failure s -> [| ""; "Erreur: " ^ s |]
  | e -> [| ""; "Erreur: " ^ Printexc.to_string e |]

(* Fonctions pour graphes dépendances programmes ---------------------------- *)
let getPgmAux ?(dir = "LR") ?(size = 10) ?(titre = "") (bcours : cours list)
    (pgm : string) : string * element_graphe list =
  let p = assoc pgm GcpLib.Programmes.l_pgms in
  let lc_ob = cours_pgm_par_type p OB in
  let lres = graphe_pgm bcours p in
  if lres = [] then ("vide", lres)
  else if filter (function Noeud _ -> true | _ -> false) lres = [] then
    ("aucun_noeud", lres)
  else if not (graphe_coherent lres) then ("incoherent", lres)
  else
    let spr = spr_cours bcours in
    ( fold_left
        (fun acc r ->
          match r with
          | Noeud (id, lnc) -> acc ^ spr id lnc (ob_ou_op lc_ob lnc)
          | Arete (id1, id2) -> acc ^ Printf.sprintf "%s -> %s\n" id1 id2)
        "" lres,
      lres )

let getPgmGv ?(dir = "LR") ?(size = 10) ?(titre = "") (bcours : cours list)
    (pgm : string) : string array =
  try
    let gv, _ = getPgmAux ~dir ~size ~titre bcours pgm in
    if gv = "vide" then [| "vide"; "" |]
    else if gv = "aucun_noeud" then [| ""; "Erreur: Aucun cours défini!" |]
    else if gv = "incoherent" then
      [| ""; "Erreur: Identificateur de cours non défini!" |]
    else [| header ~dir ~size ~titre () ^ gv ^ footer; "" |]
  with
  | Non_Implante s -> [| ""; s |]
  | Failure s -> [| ""; "Erreur: " ^ s |]
  | e -> [| ""; "Erreur: " ^ Printexc.to_string e |]

let getPgmGv2 ?(dir = "LR") ?(size = 10) ?(titre = "") (bcours : cours list)
    (pgm : string) : string array =
  try
    let gv, lres = getPgmAux ~dir ~size ~titre bcours pgm in
    if gv = "vide" then [| "vide"; "" |]
    else if gv = "aucun_noeud" then [| ""; "Erreur: Aucun cours défini!" |]
    else if gv = "incoherent" then
      [| ""; "Erreur: Identificateur de cours non défini!" |]
    else
      let ordre_sessions = ordonner_id_cours_par_session lres in
      let gvordre = spr_ordre ordre_sessions in
      [| header ~dir ~size ~titre () ^ gv ^ gvordre ^ footer; "" |]
  with
  | Non_Implante s -> [| ""; s |]
  | Failure s -> [| ""; "Erreur: " ^ s |]
  | e -> [| ""; "Erreur: " ^ Printexc.to_string e |]

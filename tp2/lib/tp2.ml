(******************************************************************************)
(*  TP2 Hiver 2024 - Langages de programmation (IFT-3000)                     *)
(*  Gestion de cours et de programmes - Dépendances de cours (suite du Tp1)   *)
(******************************************************************************)
(******************************************************************************)
(* NOM: _________________             PRÉNOM: _____________________           *)
(* MATRICULE: ___________             PROGRAMME: __________________           *)

(* NOM: _________________             PRÉNOM: _____________________           *)
(* MATRICULE: ___________             PROGRAMME: __________________           *)

(* NOM: _________________             PRÉNOM: _____________________           *)
(* MATRICULE: ___________             PROGRAMME: __________________           *)
(******************************************************************************)

(******************************************************************************)
(* Implantation                                                               *)
(******************************************************************************)

open GcpLib
open Gcp
open List

(*  ------------------------------------------------------------------------- *)
(*  Structures de données                                                     *)
(*  ------------------------------------------------------------------------- *)

type id_cours = string

and element_graphe =
  | Noeud of id_cours * num_cours list
  | Arete of id_cours * id_cours

(* -------------------------------------------------------------------------- *)
(* Partie réservée aux fonctions utiles ------------------------------------- *)
(* Vous pouvez ajouter les fonctions et définitions que vous voulez           *)
(* -------------------------------------------------------------------------- *)

(* -- FONCTION FOURNIE (utilisée dans le corrigé) --------------------------- *)
let pas_de_prealables pre = match pre with Aucun | CRE _ -> true | _ -> false

(* -------------------------------------------------------------------------- *)
(* Début partie code (implantation) à compléter ----------------------------- *)
(* -------------------------------------------------------------------------- *)

(* -- À IMPLANTER/COMPLÉTER (10 PTS) ---------------------------------------- *)
let ret_lnc_pre (lc : cours list) ((lnc_pgm, nc) : num_cours list * num_cours) :
    num_cours list =
  raise (Non_Implante "ret_lnc_pre non implanté")

(* -- À IMPLANTER/COMPLÉTER (10 PTS) ---------------------------------------- *)
let ret_lnc_post (lc : cours list) ((lnc_pgm, nc) : num_cours list * num_cours)
    : num_cours list =
  raise (Non_Implante "ret_lnc_post non implanté")

(* -- À IMPLANTER/COMPLÉTER (30 PTS) ---------------------------------------- *)
let graphe_pre_post_cours
    (ret_lnc : cours list -> num_cours list * num_cours -> num_cours list)
    (dir_arete : num_cours * num_cours -> element_graphe) (lc : cours list)
    ((lnc, nc) : num_cours list * num_cours) : element_graphe list =
  raise (Non_Implante "graphe_pre_post_cours non implanté")

(* -- Fonction fournie ------------------------------------------------------ *)
let graphe_pre_cours =
  graphe_pre_post_cours ret_lnc_pre (fun (x1, x2) -> Arete (x2, x1))

(* -- Fonction fournie ------------------------------------------------------ *)
let graphe_post_cours =
  graphe_pre_post_cours ret_lnc_post (fun (x1, x2) -> Arete (x1, x2))

(* -- Fonction fournie ------------------------------------------------------ *)
let graphe_cours (lc : cours list) ((lncp, nc) : num_cours list * num_cours) :
    element_graphe list =
  graphe_pre_cours lc (lncp, nc) ++ graphe_post_cours lc (lncp, nc)

(* -- À IMPLANTER/COMPLÉTER (25 PTS) ---------------------------------------- *)
let graphe_pgm (lc : cours list) (pgm : programme) : element_graphe list =
  raise (Non_Implante "graphe_pgm non implanté")

(* -- À IMPLANTER/COMPLÉTER (25 PTS) ---------------------------------------- *)
let ordonner_id_cours_par_session (elements : element_graphe list) :
    string list list =
  raise (Non_Implante "ordonner_id_cours_par_session non implanté")

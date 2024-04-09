(******************************************************************************)
(** TP2 Hiver 2024 - Langages de programmation (IFT-3000) 
    - Gestion de cours et de programmes - Dépendances de cours (suite du Tp1) *)
(******************************************************************************)

(******************************************************************************)
(* Spécification                                                              *)
(******************************************************************************)
open GcpLib
open Gcp

(** {1 Structures de données} *)

type id_cours = string

and element_graphe =
  | Noeud of id_cours * num_cours list
  | Arete of id_cours * id_cours

(** {1 Interface des fonctions fournies et exportées} *)

val graphe_pre_cours :
  cours list -> num_cours list * num_cours -> element_graphe list
(** [graphe_pre_cours bcours (lncp, nc)] 
    Retourne, sous forme d'élments de graphe, les chaines de cours préalables 
    au cours [nc]; ces chaines ne comprennent que les cours présents dans la 
    liste [lncp]. 
*)

val graphe_post_cours :
  cours list -> num_cours list * num_cours -> element_graphe list
(** [graphe_post_cours bcours (lncp, nc)] 
    Retourne, sous forme d'élments de graphe, les chaines de cours qui dépendent 
    du cours [nc]; ces chaines ne comprennent que les cours présents dans la 
    liste [lncp]. 
*)

val graphe_cours :
  cours list -> num_cours list * num_cours -> element_graphe list
(** [graphe_cours bcours (lncp, nc)] 
    Retourne, sous forme d'élments de graphe, les chaines de cours qui dépendent 
    du cours [nc] et dont il dépend; ces chaines ne comprennent que les cours 
    présents dans la liste [lncp].
*)

(** {1 Interface des fonctions exportées à implanter} *)

val ret_lnc_pre : cours list -> num_cours list * num_cours -> num_cours list
(** [ret_lnc_pre lc (lncp, nc)] 
    Retourne, à partir de la banque de cours [lc], la liste des cours présents
    dans les préalables immédiats du cours [nc], en ne retenant que ceux qui 
    font partie de [lncp].

    {b Soulève exception} {e Failure} si le cours [nc] n'est pas défini dans 
    [lc] (l'exception pourrait avoir été soulevée par une autre fonction appelée
    dans le corps de [ret_lnc_pre]).

    Exemples:

    {[# ret_lnc_pre bcours ([], "IFT-3000");;
    - : num_cours list = []
    ]}

    {[# ret_lnc_pre bcours (cours_pgm c_ift, "IFT-3000");;
    - : num_cours list =
    ["GIF-1003"; "IFT-1006"; "IFT-2008"; "GLO-2100"]
    ]}

    {[# ret_lnc_pre bcours (cours_pgm b_glo, "IFT-3000");;
    - : num_cours list =
    ["GIF-1003"; "GLO-2100"]
    ]}

    {[# ret_lnc_pre bcours (cours_pgm mp_jv, "GLO-4002");;
    - : num_cours list =
    []
    ]}

    {[# ret_lnc_pre bcours (cours_pgm c_ift, "XYZ-3000");;
      Exception: Failure "Cours <XYZ-3000> inexistant!".
    ]}
*)

val ret_lnc_post : cours list -> num_cours list * num_cours -> num_cours list
(** [ret_lnc_post lc (lncp, nc)] 
    Retourne, à partir de la banque de cours [lc], la liste des cours qui 
    admettent dans leurs préalables immédiats le cours [nc], en ne retenant que 
    ceux qui font partie de [lncp].

    {b Soulève exception} {e Failure} si le cours [nc] n'est pas défini dans 
    [lc] (l'exception pourrait avoir été soulevée par une autre fonction appelée
    dans le corps de [ret_lnc_post]).

    Exemples:

    {[# ret_lnc_post bcours ([], "IFT-3000");;
    - : num_cours list = []
    ]}

    {[# ret_lnc_post bcours (cours_pgm b_ift, "IFT-3000");;
    - : num_cours list = ["GLO-4010"]
    ]}

    {[# ret_lnc_post bcours (cours_pgm c_ift, "IFT-3000");;
    - : num_cours list = []
    ]}

    {[# ret_lnc_post bcours (cours_pgm c_ift, "IFT-1004");;
    - : num_cours list = 
    ["GIF-1001"; "GIF-1003"; "IFT-1006"; "IFT-2004"; "GLO-2005"; "SIO-2102"; 
    "SIO-2104"]
    ]}

    {[# ret_lnc_post bcours (cours_pgm b_ift, "IFT-1004");;
    - : num_cours list = 
    ["BIF-1001"; "GIF-1001"; "GIF-1003"; "IFT-1006"; "IFT-2003"; "IFT-2004";
     "GLO-2005"; "SIO-2100"; "SIO-2102"; "SIO-2104"; "SIO-2105"; "SIO-2107";
     "STT-2200"; "GLO-4001"; "BIF-4007"; "IFT-4030"; "IFT-4100"; "GIF-4105"]
    ]}

    {[# ret_lnc_post bcours (cours_pgm c_ift, "XYZ-3000");;
      Exception: Failure "Cours <XYZ-3000> inexistant!".
    ]}
*)

val graphe_pre_post_cours :
  (cours list -> num_cours list * num_cours -> num_cours list) ->
  (num_cours * num_cours -> element_graphe) ->
  cours list ->
  num_cours list * num_cours ->
  element_graphe list
(** [graphe_pre_post_cours ret_lnc dir_arete lc (lnc, nc)] 
    Retourne, à partir de la banque de cours [lc], une liste d'éléments de 
    graphe (noeuds et arêtes) correspondant aux pré ou postrequis du cours [nc].
    Les cours qui font partie des éléments du graphe résultant sont restreints à
    ceux faisant partie des cours [lnc]. L'argument [ret_lnc], une fonction, 
    permet de retourner la liste des cours pré ou postrequis à un cours donné 
    (en commençant par [nc]). L'argument [dir_arete], une fonction, permet de 
    préciser la direction de l'arête (selon qu'on s'intéresse aux pré ou 
    postrequis). 

    Deux exemples d'utilisation de cette fonction sont fournis à travers les 
    fonctions [graphe_pre_cours] et [graphe_post_cours] qui permettent 
    de retourner la liste des éléments de graphes (noeuds et arêtes) 
    correspondant resp. aux chaines de prérequis d'un cours [nc], et aux 
    chaines de cours postrequis de ce cours. Il serait donc judicieux de tester 
    [graphe_pre_post_cours] via ces 2 fonctions (c'est ce que fait le testeur).

    {b Soulève exception} {e Failure} si le cours [nc] n'est pas défini dans 
    [lc] (l'exception pourrait avoir été soulevée par une autre fonction appelée
    dans le corps de [graphe_pre_post_cours]).

    Exemples:

    {[# graphe_pre_cours bcours (cours_pgm b_ift, "IFT-3000");;
    - : element_graphe list =
      [Noeud ("GIF1003", ["GIF-1003"; "IFT-1006"]);
       Noeud ("GLO2100", ["GLO-2100"; "IFT-2008"]); Arete ("GIF1003", "IFT3000");
       Arete ("GLO2100", "IFT3000"); Noeud ("IFT1004", ["IFT-1004"]);
       Arete ("IFT1004", "GIF1003"); Arete ("GIF1003", "GLO2100")]
    ]}

    {[# graphe_pre_cours bcours (cours_pgm b_ift, "IFT-2003");;
    - : element_graphe list =
      [Noeud ("IFT1000", ["IFT-1000"]); Noeud ("MAT1919", ["MAT-1919"]);
       Noeud ("IFT1004", ["IFT-1004"]); Arete ("IFT1000", "IFT2003");
       Arete ("MAT1919", "IFT2003"); Arete ("IFT1004", "IFT2003");
       Arete ("MAT1919", "IFT1000")]
    ]}

    {[# graphe_pre_cours bcours (cours_pgm b_ift, "IFT-2103");;
    - : element_graphe list =
      [Noeud ("GIF1003", ["GIF-1003"; "IFT-1006"]);
       Noeud ("IFT3100", ["IFT-3100"]); Arete ("GIF1003", "IFT2103");
       Arete ("IFT3100", "IFT2103"); Noeud ("IFT1004", ["IFT-1004"]);
       Arete ("IFT1004", "GIF1003"); Arete ("GIF1003", "IFT3100")]
    ]}
       
    {[# graphe_pre_cours bcours (cours_pgm mp_base, "IFT-1006");;
    - : element_graphe list =
      [Noeud ("IFT1004", ["IFT-1004"]); Arete ("IFT1004", "IFT1006")]
    ]}

    {[# graphe_pre_cours bcours (cours_pgm mp_base, "GLO-2100");;
    - : element_graphe list =
      [Noeud ("GIF1003", ["GIF-1003"; "IFT-1006"]); Arete ("GIF1003", "GLO2100");
       Noeud ("IFT1004", ["IFT-1004"]); Arete ("IFT1004", "GIF1003")]
    ]}

    {[# graphe_pre_cours bcours (bcours |> List.map fst, "GLO-2100");;
    - : element_graphe list =
      [Noeud ("GIF1003", ["GIF-1003"; "IFT-1006"]); Arete ("GIF1003", "GLO2100");
       Noeud ("GLO1901", ["GLO-1901"; "IFT-1004"]); Arete ("GLO1901", "GIF1003")]
    ]}

    {[# graphe_pre_cours bcours (cours_pgm c_ift, "XYZ-3000");;
      Exception: Failure "Cours <XYZ-3000> inexistant!".
    ]}

    {[# graphe_post_cours bcours (cours_pgm b_ift, "IFT-3000");;
    - : element_graphe list =
      [Noeud ("GLO4010", ["GLO-4010"]); Arete ("IFT3000", "GLO4010")]
    ]}

    {[# graphe_post_cours bcours (cours_pgm b_ift, "IFT-2003");;
    - : element_graphe list =
      []
    ]}

    {[# graphe_post_cours bcours (cours_pgm b_ift, "IFT-2103");;
    - : element_graphe list =
      [Noeud ("IFT3113", ["IFT-3113"]); Arete ("IFT2103", "IFT3113")]
    ]}

    {[# graphe_post_cours bcours (cours_pgm mp_base, "IFT-1006");;
    - : element_graphe list =
      [Noeud ("GLO2004", ["GLO-2004"; "IFT-2007"]);
       Noeud ("GLO2100", ["GLO-2100"; "IFT-2008"]);
       Noeud ("IFT2103", ["IFT-2103"]); Noeud ("IFT3000", ["IFT-3000"]);
       Noeud ("IFT3100", ["IFT-3100"]); Arete ("IFT1006", "GLO2004");
       Arete ("IFT1006", "GLO2100"); Arete ("IFT1006", "IFT2103");
       Arete ("IFT1006", "IFT3000"); Arete ("IFT1006", "IFT3100");
       Arete ("GLO2100", "IFT3000"); Noeud ("IFT2001", ["IFT-2001"]);
       Arete ("GLO2100", "IFT2001"); Arete ("IFT3100", "IFT2103")]
    ]}

    {[# graphe_post_cours bcours (cours_pgm mp_base, "GLO-2100");;
    - : element_graphe list =
      [Noeud ("IFT2001", ["IFT-2001"]); Noeud ("IFT3000", ["IFT-3000"]);
       Arete ("GLO2100", "IFT2001"); Arete ("GLO2100", "IFT3000")]
    ]}

    {[# graphe_post_cours bcours (bcours |> List.map fst, "GLO-2100");;
    - : element_graphe list =
       [Noeud ("GLO2001", ["GLO-2001"; "IFT-2001"]);
        Noeud ("IFT3000", ["IFT-3000"]); Noeud ("IFT3001", ["IFT-3001"]);
        Noeud ("GLO3100", ["GLO-3100"]); Noeud ("GLO4009", ["GLO-4009"]);
        Noeud ("IFT4021", ["IFT-4021"]); Noeud ("IFT4022", ["IFT-4022"]);
        Noeud ("GLO4027", ["GLO-4027"]); Noeud ("IFT4029", ["IFT-4029"]);
        Noeud ("IFT4102", ["IFT-4102"]); Noeud ("GIF4104", ["GIF-4104"]);
        Noeud ("IFT4201", ["IFT-4201"]); Arete ("GLO2100", "GLO2001");
        Arete ("GLO2100", "IFT3000"); Arete ("GLO2100", "IFT3001");
        Arete ("GLO2100", "GLO3100"); Arete ("GLO2100", "GLO4009");
        Arete ("GLO2100", "IFT4021"); Arete ("GLO2100", "IFT4022");
        Arete ("GLO2100", "GLO4027"); Arete ("GLO2100", "IFT4029");
        Arete ("GLO2100", "IFT4102"); Arete ("GLO2100", "GIF4104");
        Arete ("GLO2100", "IFT4201"); Noeud ("GIF3000", ["GIF-3000"]);
        Noeud ("GIF3004", ["GIF-3004"]); Noeud ("GLO4008", ["GLO-4008"]);
        Arete ("GLO2001", "GIF3000"); Arete ("GLO2001", "GIF3004");
        Arete ("GLO2001", "GLO4008"); Noeud ("GLO4010", ["GLO-4010"]);
        Arete ("IFT3000", "GLO4010"); Noeud ("IFT4001", ["IFT-4001"]);
        Noeud ("IFT4003", ["IFT-4003"]); Arete ("IFT3001", "IFT4001");
        Arete ("IFT3001", "IFT4003"); Arete ("IFT4102", "IFT4201");
        Noeud ("GLO4030", ["GLO-4030"]); Arete ("IFT4102", "GLO4030")]
    ]}

    {[# graphe_post_cours bcours (cours_pgm c_ift, "XYZ-3000");;
      Exception: Failure "Cours <XYZ-3000> inexistant!".
    ]}
*)

val graphe_pgm : cours list -> programme -> element_graphe list
(** [graphe_pgm lc pgm] 
    Retourne, à partir de la banque de cours [lc], la liste d'éléments de 
    graphe (noeuds et arêtes) correspondant au graphe de dépendances entre cours
    du programme [pgm]. 

    Exemples:

    {[# graphe_pgm bcours mp_web;;
    - : element_graphe list =
      [Noeud ("IFT1004", ["IFT-1004"]);
       Noeud ("GIF1003", ["GIF-1003"; "IFT-1006"]);
       Noeud ("GLO2005", ["GLO-2005"; "IFT-2004"]); Arete ("IFT1004", "GIF1003");
       Arete ("IFT1004", "GLO2005"); Noeud ("GLO2004", ["GLO-2004"; "IFT-2007"]);
       Arete ("GIF1003", "GLO2004"); Noeud ("GLO3102", ["GLO-3102"]);
       Arete ("GLO2004", "GLO3102"); Noeud ("GLO3112", ["GLO-3112"]);
       Arete ("GLO3102", "GLO3112"); Arete ("GLO2005", "GLO3112")]
    ]}

    {[# graphe_pgm bcours c_ift;;
    - : element_graphe list =
      [Noeud ("IFT1004", ["IFT-1004"]); Noeud ("GLO3101", ["GLO-3101"]);
       Noeud ("GLO4000", ["GLO-4000"]); Noeud ("IFT1003", ["IFT-1003"]);
       Noeud ("IFT1700", ["IFT-1700"]); Noeud ("GIF1001", ["GIF-1001"]);
       Noeud ("GIF1003", ["GIF-1003"; "IFT-1006"]);
       Noeud ("GLO2005", ["GLO-2005"; "IFT-2004"]);
       Noeud ("SIO2102", ["SIO-2102"]); Noeud ("SIO2104", ["SIO-2104"]);
       Arete ("IFT1004", "GIF1001"); Arete ("IFT1004", "GIF1003");
       Arete ("IFT1004", "GLO2005"); Arete ("IFT1004", "SIO2102");
       Arete ("IFT1004", "SIO2104"); Noeud ("GLO2000", ["GLO-2000"; "IFT-2006"]);
       Noeud ("GLO2001", ["GLO-2001"; "IFT-2001"]);
       Noeud ("IFT3002", ["IFT-3002"]); Arete ("GIF1001", "GLO2000");
       Arete ("GIF1001", "GLO2001"); Arete ("GIF1001", "IFT3002");
       Noeud ("IFT2101", ["IFT-2101"]); Noeud ("IFT3201", ["IFT-3201"]);
       Noeud ("GLO4008", ["GLO-4008"]); Noeud ("IFT4029", ["IFT-4029"]);
       Arete ("GLO2000", "IFT2101"); Arete ("GLO2000", "IFT3201");
       Arete ("GLO2000", "GLO4008"); Arete ("GLO2000", "IFT4029");
       Arete ("GLO2001", "GLO4008"); Noeud ("GLO2004", ["GLO-2004"; "IFT-2007"]);
       Noeud ("GLO2100", ["GLO-2100"; "IFT-2008"]);
       Noeud ("IFT2103", ["IFT-2103"]); Noeud ("IFT3000", ["IFT-3000"]);
       Noeud ("IFT3100", ["IFT-3100"]); Arete ("GIF1003", "GLO2004");
       Arete ("GIF1003", "GLO2100"); Arete ("GIF1003", "IFT2103");
       Arete ("GIF1003", "IFT3000"); Arete ("GIF1003", "IFT3100");
       Noeud ("GLO2003", ["GLO-2003"]); Noeud ("GLO3102", ["GLO-3102"]);
       Noeud ("GLO4002", ["GLO-4002"]); Arete ("GLO2004", "GLO2003");
       Arete ("GLO2004", "GLO3102"); Arete ("GLO2004", "GLO4002");
       Arete ("GLO2003", "GLO4002"); Noeud ("IFT2102", ["IFT-2102"]);
       Arete ("GLO2003", "IFT2102"); Noeud ("GLO3112", ["GLO-3112"]);
       Noeud ("GLO3202", ["GLO-3202"]); Arete ("GLO3102", "GLO3112");
       Arete ("GLO3102", "GLO3202"); Arete ("GLO4002", "GLO4008");
       Noeud ("GLO4003", ["GLO-4003"]); Arete ("GLO4002", "GLO4003");
       Arete ("GLO2100", "GLO2001"); Arete ("GLO2100", "IFT3000");
       Arete ("GLO2100", "IFT4029"); Noeud ("GLO4009", ["GLO-4009"]);
       Noeud ("GLO4027", ["GLO-4027"]); Noeud ("GIF4104", ["GIF-4104"]);
       Arete ("GLO2100", "GLO4009"); Arete ("GLO2100", "GLO4027");
       Arete ("GLO2100", "GIF4104"); Noeud ("IFT3113", ["IFT-3113"]);
       Arete ("IFT2103", "IFT3113"); Arete ("IFT3100", "IFT2103");
       Arete ("GLO2005", "GLO3112"); Arete ("GLO2005", "GLO4027");
       Noeud ("GLO4035", ["GLO-4035"]); Arete ("GLO2005", "GLO4035");
       Arete ("IFT1003", "IFT2102")]
    ]}

*)

val ordonner_id_cours_par_session : element_graphe list -> string list list
(** [ordonner_id_cours_par_session graphe] 
    Retourne la liste des numéros d'identification, dans les arêtes du graphe,
    ordonnés par ordre de dépendances. 

    Exemples:

    {[# ordonner_id_cours_par_session (graphe_pgm bcours c_ift);;
    - : string list list =
      [["IFT1700"; "IFT1003"; "GLO4000"; "GLO3101"; "IFT1004"];
       ["SIO2104"; "SIO2102"; "GLO2005"; "GIF1003"; "GIF1001"];
       ["GLO4035"; "IFT3100"; "GLO2100"; "GLO2004"; "IFT3002"; "GLO2000"];
       ["GIF4104"; "GLO4027"; "GLO4009"; "GLO3102"; "GLO2003"; "IFT3000";
        "IFT2103"; "IFT4029"; "IFT3201"; "IFT2101"; "GLO2001"];
       ["IFT3113"; "GLO3202"; "GLO3112"; "IFT2102"; "GLO4002"];
       ["GLO4003"; "GLO4008"]]
    ]}

    {[# ordonner_id_cours_par_session (graphe_pgm bcours mp_base);;
    - : string list list =
      [["IFT1700"; "IFT1003"; "IFT1004"]; ["IFT2004"; "GIF1003"; "GIF1001"];
       ["IFT3100"; "GLO2100"; "GLO2004"; "IFT3002"; "IFT2006"];
       ["IFT3000"; "IFT2103"; "IFT2001"]]
   ]}

*)

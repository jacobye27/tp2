(* INTERFACE AVEC JS_OF_OCAML *)
open Js_of_ocaml

let _ =
  Js.export_all
    (object%js
       method genDep pgm nc =
         let t = Gengraph.getGv GcpLib.Cours.bcours (Js.to_string pgm) nc in
         let t' = Array.map Js.string t in
         Js.array t'

       method genPgmDep pgm =
         let t = Gengraph.getPgmGv GcpLib.Cours.bcours (Js.to_string pgm) in
         let t' = Array.map Js.string t in
         Js.array t'

       method genPgmDep2 pgm =
         let t = Gengraph.getPgmGv2 GcpLib.Cours.bcours (Js.to_string pgm) in
         let t' = Array.map Js.string t in
         Js.array t'
    end)

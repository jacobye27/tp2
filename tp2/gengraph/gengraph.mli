open GcpLib
open Gcp

val getGv :
  ?dir:string ->
  ?size:int ->
  ?titre:string ->
  cours list ->
  string ->
  num_cours ->
  string array

val getPgmGv :
  ?dir:string ->
  ?size:int ->
  ?titre:string ->
  cours list ->
  string ->
  string array

val getPgmGv2 :
  ?dir:string ->
  ?size:int ->
  ?titre:string ->
  cours list ->
  string ->
  string array

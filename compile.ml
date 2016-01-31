open Printf

type reg =
	| EAX
	| ESP

type arg =
  | Const of int
  | Reg of reg
  | RegOffset of int * reg

type instruction =
	| IMov of arg * arg
  | IAdd of arg * arg
	| IRet

type prim1 =
  | Add1
  | Sub1

type program =
	| Number of int
  | Prim1 of prim1 * program
  | Let of string * program * program
  | Id of string

let reg_to_asm_string (r : reg) : string =
	match r with
		| EAX -> "eax"
		| ESP -> failwith "ESP not yet implemented"

let arg_to_asm_string (a : arg) : string =
  match a with
    | Const(n) -> sprintf "%d" n
    | Reg(r) -> reg_to_asm_string r
    | RegOffset(n, r) ->
      failwith "RegOffset not yet implemented"

let instruction_to_asm_string (i : instruction) : string =
	match i with
		| IMov(dest, value) ->
			sprintf "	mov %s, %s" (arg_to_asm_string dest) (arg_to_asm_string value)
		| IRet ->
			"	ret"
		| IAdd(dest, to_add) ->
      failwith "IAdd not yet implemented"

let to_asm_string (is : instruction list) : string =
  List.fold_left (fun s i -> sprintf "%s\n%s" s (instruction_to_asm_string i)) "" is

let rec find (ls : (string * int) list) (x : string) =
  match ls with
    | [] -> None
    | (y,v)::rest ->
      if y = x then Some(v) else find rest x

let rec compile_env
    (p : program)
    (stack_index : int)
    (env : (string * int) list)
  : instruction list =
	match p with
		| Number(n) ->
			[
				IMov(Reg(EAX), Const(n))
			]
    | Let(id, e, body) ->
      failwith "let not yet implemented"
    | Id(x) ->
      failwith "id not yet implemented"
    | Prim1(op, e) ->
      failwith "prim1 not yet implemented"

let compile (p : program) : instruction list =
  compile_env p 1 []

let compile_to_string prog =
  let prelude = 
"section .text
global our_code_starts_here
our_code_starts_here:" in
  let asm_string = (to_asm_string ((compile prog) @ [IRet])) in
	let asm_program = sprintf "%s%s\n" prelude asm_string in
  asm_program


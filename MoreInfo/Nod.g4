
// Copyright (C) 2020 - 2024 John Steven Matthews

grammar Nod; 
    

// =====================  LEXER  =============================

// trailing underscores avoid collisions in generated C++ code

// keywords

ABSTRACT			:	'abstract'		;
AFTER				:	'after'			;
ALIGN				:	'align'			;
AS					:	'as'			;
BASE				:	'base'			;
COMMON				:	'common'		;	
COMPATIBLE			:	'compatible'	;		
CONST_				:	'const'			;		// constant
CRUDE				:	'crude'			;
EACH				:	'each'			;
ELSE				:	'else'			;
ENUM				:	'enum'			;		// enumerated
ESCAPE				:	'escape'		;
EVAL				:	'eval'			;		// evaluate
FINAL				:	'final'			;
FOR					:	'for'			;
FORMAT				:	'format'		;
FROM				:	'from'			;
GENERAL				:	'general'		;
IF					:	'if'			;
IN_					:	'in'			;
INCOMPLETE			:	'incomplete'	;
INIT				:	'init'			;		// initiate
INSTANCE			:	'instance'		;
IS					:	'is'			;
ISOLATE				:	'isolate'		;
LOOP				:	'loop'			;
METHOD				:	'method'		;
MISC				:	'misc'			;		// miscellaneous
NAF					:   'naf'			;		// not-a-function
NEW					:	'new'			;
NOM					:	'nom'			;		// nominal
NULL_				:	'null'			;
OPERATION			:	'operation'		;
OPT					:	'opt'			;		// optional
PAGE				:	'page'			;
PROXY				:	'proxy'			;	
PWD					:	'pwd'			;		// previously well-defined
QUIT				:	'quit'			;
READABLE			:	'readable'		;
RETURN				:	'return'		;
SELECT				:	'select'		;	
SUBROUTINE			:	'subroutine'	;
TBD					:	'tbd'			;		// to-be-defined 
TERM				:	'term'			;		// terminate
TRAP				:	'trap'			;
TYPE				:	'type'			;
USES				:   'uses'			;
UPD					:	'upd'			;		// update
VALUE				:	'value'			;
VOID_				:	'void'			;
WITH				:	'with'			;

// directives

IGNORE_				:	'%ignore'		;
END					:	'%end'			;
INFER				:	'%infer'		;


// punctuation and delimiters

LEFT_CURLY			:	'{'				;
RIGHT_CURLY			:	'}'				;
LEFT_PAREN			:	'('				;
RIGHT_PAREN			:	')'				;
LEFT_SQUARE			:	'['				;
RIGHT_SQUARE		:	']'				;	
COMMA				:	','				;
SEMI_COLON			:	';'				;
DOUBLE_QUOTE		:	'"'				;
EQUAL				:	'='				;
COLON				:	':'				;
ASTERISK			:	'*'				;		// also used for MULTIPLY


// native operator

JOIN				:	'->'			;
ASSIGN				:	'<='			;	


// formula operator

PLUS				: '+';
MINUS				: '-';
DIVIDE				: '/';

fragment
OP1					: [!-z{}~]					// char subset: printable, except SP and |
					;

OPERATOR			: '|' OP1+? '|'
					;


// literal 
			
fragment
LIT0				:	'\''					// delim
					;
	
fragment
LIT1				: [!-&(-\]_-~\r\n\t ]		// char subset: printable, except ^ and ', plus whitespace
					;

fragment
LIT2				: [0-9][0-9][0-9]			// 3 digits
					;

fragment			
LIT3				: '^' ( '^' | LIT0 | LIT2 )		// insert subexpr		
					;

LITERAL				: LIT0 ( LIT1 | LIT3 )*?  LIT0
					;



// identification


fragment
ID0					: ' '						// embedded space			
					;

fragment
ID1					: [a-zA-Z0-9_~@&!?]+		// name, char subset = alphanumeric plus _~@&!?
					;

fragment			
ID2					: '#' [a-zA-Z0-9]* 			// symbolic dimension 
					| LIT0 [0-9]+ LIT0			// adhoc dimension
					;

fragment												
ID3					: '<' ID0* ( ID2 | ID5 ) ID0* '>'	// factor   
					;

fragment										// with factors (type,method,subroutine)
ID4					: ID1 ( ID3+ ID1 )* ID3*	
					| ID3+ ( ID1 ID3+ )* ID1?
					;

fragment
ID5					: ( ID1 '\\' )? ID4			// qualified  
					;


FID					: ID5						// no sub-object
					| (( ID1 '\\' )? ID1 )? '.' ID1	// sub-object 
					;
					

// exclusion 


REGION				: IGNORE_ .*? END		-> skip
					;

NARRATIVE			: '{{' .*? '}}'			-> skip
					;

REMARK				: '--' ~[\r\n]*			-> skip 
					;



// space (lowest precedence)

SPACE				: [ \t\r\n]+			-> skip
					;



// =====================  PARSER  ===========================
/*
		
	Imperative items can be grouped into blocks.
	
	Items and blocks can be incorporated into imperative
	forms:  if/else, loop, for-each, select/value/else, 
	isolate/trap.
	
	FID = Formal IDentifier

	Possible object expressions:
	
	FID						type ref:  new anon null obj, type = FID
	FID						obj ref:  existing obj, type = per def
	FID						proxy ref: existing obj, type = per proxy 
	FID						dimension: new anon initialized obj, type = expr
	FID						trivial subroutine call: type = per proxy
	NULL_					new anon null input/output obj, type = per spec 
	LITERAL					new anon initialized obj, type = expr 
	new_obj					new named null obj, type and name specified
	new_analog				new anon initialized obj, type = analog 
	formula					new anon initialized obj, type = contextual 
	conversion				new anon initialized obj, type = specified
	method_call_sequence	existing result obj (method obj, result	proxy, designated output)
	subroutine_call			existing result obj (result proxy, designated output)
*/



// -------------------------------------------------   IMPERATIVE



new_proxy_name			: FID
						;

new_proxy				: proxy_header proxy_attribution? new_proxy_name
						;


new_obj_type_ref		: FID
						;

new_obj_name			: FID
						;

new_obj					: new_obj_type_ref new_obj_name	
						;


new_analog_ref			: FID	// proxy ref
						;

new_analog				: LEFT_SQUARE new_analog_ref RIGHT_SQUARE 
						;


conversion_type_ref		: FID
						;

conversion_chain		: ( AS conversion_type_ref )+
						;

conversion_obj			: LITERAL
						| FID
						| formula
						| method_call_sequence
						| subroutine_call
						;

conversion				: conversion_obj conversion_chain
						;


assignment_input		: LITERAL
						| FID
						| formula
						| method_call_sequence
						| subroutine_call
						| conversion
						;

assignment_obj			: FID	
						| method_call_sequence
						| subroutine_call
						;

assignment				: assignment_obj ASSIGN ASTERISK? assignment_input 
						;



association_obj			: VOID_
						| LITERAL
						| FID
						| formula
						| method_call_sequence
						| subroutine_call
						| conversion
						;	

association_proxy		: FID	// proxy ref
						| new_proxy
						;

association				: association_proxy JOIN association_obj
						;



formula_operand			: LITERAL
						| FID
						| formula_closure
						| formula_call
						| formula_operand ( AS FID )+  // special case conversion
						;

formula_term			: operator_? formula_operand
						;

formula_product			: formula_term ( operator_ formula_term )*   
						;

formula_closure			: LEFT_PAREN formula_product RIGHT_PAREN
						;

formula_input			: NULL_
						| new_analog
						| formula_product
						;

formula_ref				: FID  // proc ref
						;

formula_call			: formula_ref LEFT_PAREN ( formula_input ( COMMA formula_input )* )? RIGHT_PAREN
						;

formula					: DOUBLE_QUOTE formula_product DOUBLE_QUOTE 
						;



input_obj				: NULL_
						| LITERAL
						| FID
						| formula
						| method_call_sequence
						| subroutine_call	
						| conversion
						;

input_obj_item			: ASTERISK? input_obj
						;

input_obj_enum			: input_obj_item ( COMMA input_obj_item )*
						;

input_obj_list			: LEFT_PAREN input_obj_enum? RIGHT_PAREN		
						;


output_obj				: NULL_
						| FID
						| new_obj	
						| method_call_sequence	   
						| subroutine_call  
						;

output_obj_item			: EQUAL? output_obj
						;

output_obj_enum			: output_obj_item ( COMMA output_obj_item )*	// only one result
						;

output_obj_list			: LEFT_PAREN output_obj_enum? RIGHT_PAREN	
						;


extra_obj				: NULL_
						| LITERAL
						| FID
						| new_obj
						| formula
						| method_call_sequence
						| subroutine_call	
						| conversion
						;

extra_obj_enum			: extra_obj ( COMMA extra_obj )*
						;

extra_obj_list			: LEFT_PAREN extra_obj_enum? RIGHT_PAREN
						;




reg_given_obj_list		: input_obj_list
						| input_obj_list output_obj_list
						| input_obj_list output_obj_list extra_obj_list
						;

aux_given_obj_list		: LEFT_PAREN input_obj_list RIGHT_PAREN  
						;



call_coroutine_ref		: FID
						;

call_coroutine			: WITH call_coroutine_ref aux_given_obj_list?	
						;


call_overt_proxy_name	: FID	
						;

call_overt_proxy		: proxy_attribution
						| IS proxy_header proxy_attribution? call_overt_proxy_name? 
						| IS proxy_attribution? call_overt_proxy_name
						;


call_provision			: reg_given_obj_list? call_coroutine? call_overt_proxy?
						;


method_obj				: LITERAL
						| FID  
						| new_obj	
						| new_analog
						| formula
						| subroutine_call	
						;

method_ref				: FID
						;

method_call				: COLON method_ref call_provision
						;

method_call_sequence	: method_obj? method_call+
						;



subroutine_ref			: FID
						;

subroutine_call			: subroutine_ref call_provision
						;



quit_type_ref			: FID			
						;

quit_obj				: quit_type_ref  method_call  // call to :begin
						;

quit					: QUIT ( WITH quit_obj )?	
						;



after					: AFTER ( subroutine_call | method_call_sequence | association | assignment )
						;


escape					: ESCAPE after?
						;


return					: RETURN after?
						;



condition_obj			: LITERAL	
						| FID
						| formula
						| method_call_sequence
						| subroutine_call
						;

condition				: LEFT_PAREN condition_obj RIGHT_PAREN	
						;


						
if						: IF condition exec_element
						| IF condition ( exec_element | exec_block ) ELSE exec_element
						;

if_block				: IF condition exec_block
						| IF condition ( exec_element | exec_block ) ELSE exec_block
						;


loop					: LOOP condition? exec_element	
						| LOOP condition		// pure loop
						;

loop_block				: LOOP condition? exec_block
						;



for_each_collection_obj	: FID	
						| method_call_sequence
						| subroutine_call
						;

for_each_index_obj		: FID	
						| new_obj	
						;

for_each_item_spec		: proxy_header? proxy_attribution?
						;

for_each_item_name		: FID  // proxy 
						;

for_each_list			: LEFT_PAREN for_each_item_spec for_each_item_name IN_ for_each_collection_obj ( COMMA for_each_index_obj )? RIGHT_PAREN
						;

for_each				: FOR EACH for_each_list exec_element
						;

for_each_block			: FOR EACH for_each_list exec_block
						;



isolate					: ISOLATE exec_element 
						| ISOLATE ( exec_element | exec_block ) TRAP exec_element 
						;

isolate_block			: ISOLATE exec_block
						| ISOLATE ( exec_element | exec_block ) TRAP exec_block
						;



select_value_obj		: LITERAL		 
						| FID		// pure const 
						;

select_value_list		: LEFT_PAREN select_value_obj ( COMMA select_value_obj )* RIGHT_PAREN
						;

select_branch_label		: VALUE select_value_list
						;

select_key_obj			: FID
						| formula
						| method_call_sequence
						| subroutine_call	
						;

select_labeled_branch	: select_branch_label exec_element? SEMI_COLON
						| select_branch_label ( COMMA? select_branch_label )* plain_block
						;

select_default_branch	: ELSE ( exec_block | exec_element SEMI_COLON )
						;

select_null_branch		: ELSE ( exec_block | exec_element SEMI_COLON )
						;

select_block			: SELECT LEFT_PAREN select_key_obj RIGHT_PAREN LEFT_CURLY select_labeled_branch* select_default_branch? RIGHT_CURLY select_null_branch?
						;



plain_block				: LEFT_CURLY exec_item* RIGHT_CURLY	
						;


exec_element			: new_obj	
						| new_proxy
						| association
						| assignment
						| method_call_sequence	
						| subroutine_call
						| if
						| loop
						| for_each
						| isolate
						| quit
						| escape
						| return
						;

exec_block				: plain_block			
						| if_block
						| loop_block
						| for_each_block
						| isolate_block
						| select_block
						;

exec_item				: exec_element? SEMI_COLON 
						| exec_block	
						;

non_exec_item			: subroutine
						| enum_type
						| nom_type
						| crude_type
						| operation
						| common_obj	
						;

proc_block				: LEFT_CURLY non_exec_item* exec_item* RIGHT_CURLY
						;


infer_block				: LEFT_CURLY INFER RIGHT_CURLY
						;


//-----------------------------------------------------------------  DECLARATIVE



proxy_attribute			: EVAL 
						| UPD
						| INIT
						| EVAL COMMA UPD
						| EVAL COMMA INIT
						| EVAL COMMA UPD COMMA INIT  // reserved 
						;

proxy_attribution		: LEFT_SQUARE proxy_attribute RIGHT_SQUARE
						;


proxy_header_type_ref	: FID
						;

proxy_header			: proxy_header_type_ref PROXY
						;


input_spec_type_ref		: FID
						;

input_spec_obj_name		: FID
						;

input_spec_attribute	: OPT
						| UPD
						;

input_spec_attribution	: LEFT_SQUARE input_spec_attribute RIGHT_SQUARE
						;

input_spec				: input_spec_type_ref input_spec_obj_name? input_spec_attribution?
						;

input_spec_enum			: input_spec ( COMMA input_spec )*
						;

input_spec_list			: LEFT_PAREN input_spec_enum? RIGHT_PAREN
						;


output_spec_type_ref	: FID
						;

output_spec_obj_name	: FID
						;

output_spec				: output_spec_type_ref output_spec_obj_name?
						;

output_spec_enum		: output_spec ( COMMA output_spec )*
						;

output_spec_list		: LEFT_PAREN output_spec_enum? RIGHT_PAREN
						;



extra_spec_type_ref		: FID  // alpha\extra
						;

extra_spec_obj_name		: FID
						;

extra_spec				: extra_spec_type_ref extra_spec_obj_name?
						;

extra_spec_list			: LEFT_PAREN extra_spec RIGHT_PAREN	
						;


reg_obj_spec_list		: input_spec_list 
						| input_spec_list output_spec_list
						| input_spec_list output_spec_list extra_spec_list
						;

aux_obj_spec_list		: LEFT_PAREN input_spec_list RIGHT_PAREN 
						;


coroutine_name			: FID
						;

coroutine_spec			: WITH coroutine_name reg_obj_spec_list?
						;


proxy_result_name		: FID
						;

proxy_result			: EQUAL proxy_header proxy_attribution? proxy_result_name?
						;



subroutine_name			: FID
						;

subroutine_attribution	: LEFT_SQUARE NAF RIGHT_SQUARE
						;

subroutine_interface	: subroutine_attribution? aux_obj_spec_list? reg_obj_spec_list? coroutine_spec? proxy_result?
						;

subroutine_def			: subroutine_name subroutine_interface ( proc_block | SEMI_COLON )
						;

subroutine				: SUBROUTINE subroutine_def
						;

subroutine_group		: SUBROUTINE LEFT_CURLY subroutine_def* RIGHT_CURLY
						;



method_attribute		: ( EVAL | UPD | INIT | TERM ) ( COMMA NAF )?
						| NAF
						;

method_attribution		: LEFT_SQUARE method_attribute RIGHT_SQUARE
						;

method_interface		: method_attribution? reg_obj_spec_list? coroutine_spec? proxy_result? 
						;

method_name				: FID
						;

method_def				: method_name method_interface ( proc_block | infer_block | SEMI_COLON )
						;

method					: ( GENERAL | ABSTRACT | BASE | MISC  ) METHOD method_def
						;

method_group			: ( GENERAL | ABSTRACT | BASE | MISC  ) METHOD? LEFT_CURLY method_def* RIGHT_CURLY
						;



recap_attribute			: TBD
						| ( PWD | NEW ) ( COMMA FINAL )?
						| FINAL
						;

recap_attribution		: LEFT_SQUARE recap_attribute RIGHT_SQUARE
						;

recap_base_ref			: FID
						;

recap_method_def		: recap_attribution? method_def
						;

recap_method			: ABSTRACT METHOD IN_ recap_base_ref recap_method_def
						;

recap_method_group		: ABSTRACT METHOD? IN_ recap_base_ref LEFT_CURLY recap_method_def* RIGHT_CURLY	
						;



instance_item_type_ref		: FID
							;

instance_item_obj_name		: FID
							;

instance_item_attribute		: OPT
							;

instance_item_attribution	: LEFT_SQUARE instance_item_attribute RIGHT_SQUARE
							;

instance_item				: instance_item_type_ref instance_item_obj_name? instance_item_attribution? SEMI_COLON 
							;

instance_block				: LEFT_CURLY instance_item* RIGHT_CURLY
							;

instance					: INSTANCE instance_block
							;



format_item_fex			: LITERAL
						;

format_item_fex_list	: LEFT_PAREN format_item_fex ( COMMA format_item_fex )* RIGHT_PAREN		
						;

format_item_label		: LITERAL
						;

format_item_ref			: FID 
						;

format_item				: format_item_ref format_item_label? format_item_fex_list? SEMI_COLON
						| FORMAT format_item_ref format_item_label? SEMI_COLON
						;

format_block			: LEFT_CURLY format_item* RIGHT_CURLY
						;

format_name				: FID
						;

format_key				: LITERAL
						;

format_attribute		: READABLE
						| COMPATIBLE ( COMMA ALIGN )?
						;
						
format_attribution		: LEFT_SQUARE format_attribute RIGHT_SQUARE 
						;

format_def				: format_name? format_key? format_attribution? ( format_block | infer_block | SEMI_COLON )
						;

format					: FORMAT format_def
						;

						

nom_type_name			: FID
						;

nom_type_ref			: FID
						;

nom_type_def			: nom_type_name ( EQUAL nom_type_ref )? SEMI_COLON
						;

nom_type				: NOM TYPE nom_type_def
						;

nom_type_group			: NOM TYPE LEFT_CURLY nom_type_def* RIGHT_CURLY
						;

						

enum_type_value			: LITERAL 
						;

enum_type_list			: LEFT_PAREN enum_type_value ( COMMA enum_type_value )* RIGHT_PAREN
						;

enum_type_name			: FID	
						;

enum_type_def			: enum_type_name enum_type_list? SEMI_COLON
						;

enum_type				: ENUM TYPE enum_type_def
						;

enum_type_group			: ENUM TYPE LEFT_CURLY enum_type_def* RIGHT_CURLY
						;



crude_type_item_obj_name	: FID
							;

crude_type_item_type_ref	: FID
							;

crude_type_item				: crude_type_item_type_ref crude_type_item_obj_name? SEMI_COLON 
							;

crude_type_block			: LEFT_CURLY crude_type_item* RIGHT_CURLY
							;

crude_type_name				: FID
							;

crude_type_def				: crude_type_name ( crude_type_block | SEMI_COLON )
							;

crude_type					: CRUDE TYPE crude_type_def
							;



operator_				:  OPERATOR
						| ( PLUS | MINUS | ASTERISK | DIVIDE )
						;


operation_ref			: FID
						;

operation_input			: NULL_
						| LITERAL
						| operation_operand	
						| operation_function
						;

operation_function		: operation_ref LEFT_PAREN operation_input ( COMMA operation_input )* RIGHT_PAREN	
						;

operation_operand		: FID		
						;

operation_unary_expr	: operator_ operation_operand
						;

operation_qnary_expr	: operation_operand ( operator_ operation_operand )+ 
						;

operation_expr			: operation_unary_expr
						| operation_qnary_expr
						;

operation_right_side	: EQUAL DOUBLE_QUOTE operation_function DOUBLE_QUOTE
						;

operation_left_side		: DOUBLE_QUOTE operation_expr DOUBLE_QUOTE
						;

operation_def			: operation_left_side operation_right_side? SEMI_COLON
						;
					
operation				: OPERATION operation_def
						;

operation_group			: OPERATION LEFT_CURLY operation_def* RIGHT_CURLY
						;



common_obj_type_ref		: FID
						;

common_obj_name			: FID
						;

common_obj_attribute	: CONST_
						;

common_obj_attribution	: LEFT_SQUARE common_obj_attribute RIGHT_SQUARE
						;

common_obj_proc			: FID proc_block   // FID = begin
						;

common_obj_def			: common_obj_type_ref common_obj_name method_call? common_obj_attribution? SEMI_COLON  // method_call = :begin with literal inputs only
						;

common_obj				: COMMON common_obj_def 
						;

common_obj_group		: COMMON LEFT_CURLY common_obj_def* common_obj_proc? RIGHT_CURLY
						;


type_item				: common_obj
						| common_obj_group
						| operation
						| operation_group
						| nom_type
						| nom_type_group
						| enum_type
						| enum_type_group
						| crude_type
						| subroutine
						| subroutine_group
						| method
						| method_group
						| recap_method
						| recap_method_group
						| instance
						| format
						;

type_item_group			: LEFT_CURLY type_item* RIGHT_CURLY
						;

type_base_ref			: FID
						;

type_base_list			: LEFT_PAREN type_base_ref ( COMMA type_base_ref )* RIGHT_PAREN
						;

type_from				: FROM ( type_base_ref | type_base_list )
						;

type_from_sequence		: type_from ( COMMA? type_from )*
						;

type_attribute			: INCOMPLETE
						;

type_attribution		: LEFT_SQUARE type_attribute RIGHT_SQUARE
						;

type_name				: FID
						;

type_def				: type_name type_attribution? type_from_sequence? ( type_item_group | SEMI_COLON )
						;

type					: TYPE type_def
						;




page_internal			: LEFT_SQUARE PAGE RIGHT_SQUARE
						;

page_item				: page_internal? common_obj
						| page_internal? common_obj_group
						| page_internal? operation
						| page_internal? operation_group
						| page_internal? enum_type
						| page_internal? enum_type_group
						| page_internal? nom_type
						| page_internal? nom_type_group
						| page_internal? crude_type
						| page_internal? subroutine
						| page_internal? subroutine_group
						| page_internal? type
						;
						
page_uses_book_alias	: FID
						;

page_uses_book_ref		: FID
						;

page_uses_item			: page_uses_book_ref ( AS page_uses_book_alias )?
						;

page_uses_list			: LEFT_PAREN page_uses_item ( COMMA page_uses_item )* RIGHT_PAREN
						;

page_uses				: USES ( page_uses_item | page_uses_list )
						;

page_attribute			: COMPATIBLE
						;

page_attribution		: LEFT_SQUARE page_attribute RIGHT_SQUARE
						;

page_book_ref			: FID
						;

page_name				: FID
						;

page_header				: page_name IN_ page_book_ref page_attribution? page_uses*
						;

page					: PAGE page_header page_item* EOF
						;




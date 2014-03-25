/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then AST.
 */

{
  var tree = function(f, r) {
    if (r.length > 0) {
      var last = r.pop();
      var result = {
        type:  last[0],
        left: tree(f, r),
        right: last[1]
      };
    }
    else {
      var result = f;
    }
    return result;
  }
}

program = b:block DOT { return b; }
block   =  constants:(block_const)? vars:(block_vars)? procs:(block_proc)* s:statement {
  // Concatenar todo
  var ids = [];
  if(constants) ids = ids.concat(constants);
  if(vars) ids = ids.concat(vars);
  if(procs) ids = ids.concat(procs);
  
  return ids.concat([s]);
}

  // Reglas auxiliares para block
  block_const               = c1:block_const_assign c2:block_const_assign_others* {return [c1].concat(c2); }
  block_const_assign        = CONST i:CONST_ID ASSIGN n:NUM { return {type: "=", left: i, right: n}; }
  block_const_assign_others = COMMA i:CONST_ID ASSIGN n:NUM { return {type: "=", left: i, right: n}; }
  
  block_vars               = VAR v1:VAR_ID v2:(COMMA v:VAR_ID {return v})* {return [v1].concat(v2); }
  
  block_proc               = PROCEDURE i:PROC_ID SEMICOLON b:block SEMICOLON {return {type: "PROCEDURE", value: i, body: b }; }
  
statement = i:ID ASSIGN e:exp                                               { return {type: '=', left: i, right: e}; }
          / CALL i:PROC_ID                                                  { return {type: "CALL", value: i}; }
		  / BEGIN s1:statement s2:(SEMICOLON s:statement {return s;})* END  { return {type: "I_BLOCK", value: [s1].concat(s2)};}
          / IF e:exp THEN st_true:statement ELSE st_false:statement         { return {type: "IFELSE", condition: e, true_statement: st_true, false_statement: st_false}; }
	      / IF e:exp THEN s:statement                                       { return {type: "IF", condition: e, statement: s}; }
		  / /* empty */ { return ""; }
		

exp     = t:term   r:(ADD term)*   { return tree(t,r); }
term    = f:factor r:(MUL factor)* { return tree(f,r); }

factor = NUM
       / ID
       / LEFTPAR t:exp RIGHTPAR   { return t; }

_ = $[ \t\n\r]*

PROCEDURE = _"PROCEDURE"_
CALL      = _"CALL"_
CONST     = _"CONST"_
VAR       = _"VAR"_
BEGIN     = _"BEGIN"_
END       = _"END"_
COMMA     = _","_
SEMICOLON = _";"_
DOT       = _"."_
ASSIGN    = _ op:'=' _  { return op; }
ADD       = _ op:[+-] _ { return op; }
MUL       = _ op:[*/] _ { return op; }
LEFTPAR   = _"("_
RIGHTPAR  = _")"_
IF        = _"IF"_
THEN      = _"THEN"_
ELSE      = _"ELSE"_
PROC_ID   = _ id:$([a-zA-Z_][a-zA-Z_0-9]*) _  { return { type: 'PROCEDURE ID', value: id }; }
CONST_ID  = _ id:$([a-zA-Z_][a-zA-Z_0-9]*) _  { return { type: 'CONST ID', value: id }; }
VAR_ID    = _ id:$([a-zA-Z_][a-zA-Z_0-9]*) _  { return { type: 'VAR ID', value: id };  }
ID        = _ id:$([a-zA-Z_][a-zA-Z_0-9]*) _  { return { type: 'ID', value: id }; }
NUM       = _ digits:$[0-9]+ _              { return { type: 'NUM', value: parseInt(digits, 10) }; }

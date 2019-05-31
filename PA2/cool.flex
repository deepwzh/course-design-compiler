/*
 *  The scanner definition for COOL.
  */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Dont remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

%}
STR_CONST [^\"]*
 /* String  
  Keyword
  WhiteSpace
 */
/*
 * Define names for regular expressions here.
 */
DARROW          =>
typeid [A-Z][A-Za-z0-9_]*
objectid [a-z][A-Za-z0-9_]*
DIGIT [0-9]
%x COMMENT
%x STRING
%%
 /*
  *  Nested comments
  */
"(*" {
  BEGIN(COMMENT);
}

<COMMENT>"*)" {
  BEGIN(0);
}
<COMMENT>\n {
  curr_lineno++;
}
<COMMENT><<EOF>> {
  yylval.error_msg = "EOF in comment";
  BEGIN 0;
  return ERROR;
  // yyless(2);
  // BEGIN(0);
}
<COMMENT>. {

} 
 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }
class { return CLASS; }
else { return ELSE; }
fi { return FI; }
if { return IF; }
in { return IN; }
inherits { return INHERITS; }
let { return LET; }
loop { return LOOP; }
pool { return POOL; }
then { return THEN; }
while { return WHILE; }
case { return CASE; }
esac { return ESAC; }
of { return OF; }
new { return NEW;}
isvoid { return ISVOID; }
[ \f\r\t\v] {}
{typeid} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (TYPEID);
}
{objectid} { 
  cool_yylval.symbol = idtable.add_string(yytext);
  return (OBJECTID);
}

{DIGIT}+ {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (INT_CONST);
}
<INITIAL>(\") {
 BEGIN(STRING); 
}
<STRING>(\") {
  BEGIN(0);
}
 /*<STRING>[^\\]\n {
  yylval.error_msg = "Unterminated string constant";
  return ERROR;
}
<STRING><<EOF>> {

  yylval.error_msg = "";
  return ERROR;
}
 */
 /* <STRING>\0 {

  yylval.error_msg = "EOF in comment";
  return ERROR;
 } */
<STRING>{STR_CONST} { 
  std::string input(yytext, yyleng);
//  input.replace()
  cool_yylval.symbol = stringtable.add_string((char*)input.c_str());
  return STR_CONST;
}
"\n" {
  curr_lineno++;
}
 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
 /* ASSIGN */
"<-" { return ASSIGN; }

"<=" { return LE; }

"+" { return int('+'); }

"-" { return int('-'); }

"*" { return int('*'); }

"/" { return int('/'); }

"<" { return int('<'); }

"=" { return int('='); }

"." { return int('.'); }

";" { return int(';'); }

"~" { return int('~'); }

"{" { return int('{'); }

"}" { return int('}'); }

"(" { return int('('); }

")" { return int(')'); }

":" { return int(':'); }

"@" { return int('@'); }

"," { return int(','); }

. {
  yylval.error_msg = yytext;
  return ERROR;
} 
%%

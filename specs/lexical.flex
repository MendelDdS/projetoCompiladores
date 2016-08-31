/**
 * Lexical Specification
 *
 */
package compiler.generated;
import java_cup.*;
import java_cup.runtime.*;

%%

%class Scanner
%unicode
%line
%public
%column
%cup
%cupdebug

%{

  StringBuffer string = new StringBuffer();
  public static String curLine;

  /**
   * Factory method for creating Symbols for a given type.
   * @param type The type of this symbol
   * @return A symbol of a specific type
   */
  public Symbol symbol(int type) {
      curLine = "line :" + yyline;
      return new Symbol(type, yyline, yycolumn);
  }

  /**
   * Factory method for creating Symbols for a given type and its value.
   * @param type The type of this symbol
   * @param value The value of this symbol
   * @return A symbol of a specific type
   */
  public Symbol symbol(int type, Object value) {
      curLine = "line :" + yyline;
      return new Symbol(type, yyline, yycolumn, value);
  }

  /**
   * Reports an error occured in a given line.
   * @param line The bad line
   * @param msg Additional information about the error
   */
  private void reportError(int line, String msg) {
      throw new RuntimeException("Lexical error at line #" + line + ": " + msg);
  }

  private long parseLong(int start, int end, int radix) {
  long result = 0;
  long digit;

  for (int i = start; i < end; i++) {
    digit  = Character.digit(yycharat(i),radix);
    result*= radix;
    result+= digit;
  }

  return result;
}
%}

/* macros

D = [0-9]
L = [a-zA-Z_]
H = [a-fA-F0-9]
E = [Ee][+-]?{D}+
FS = (f|F|l|L)
IS = (u|U|l|L)*
*/

/* identifiers */
Identifier = {Letter_}({Letter}|{Alphanumerics_})*

LineTerminator = \r|\n|\r\n
WhiteSpace = {LineTerminator} | [ \t\f]

/* numeric */
IntegerLiteral = 0 | [0-9][0-9]*
DecIntegerLiteral = 0 | [1-9][0-9]*
DecLongLiteral    = {DecIntegerLiteral} [lL]

HexIntegerLiteral = 0 [xX] 0* {HexDigit} {1,8}
HexLongLiteral    = 0 [xX] 0* {HexDigit} {1,16} [lL]
HexDigit          = [0-9a-fA-F]

OctIntegerLiteral = 0+ [1-3]? {OctDigit} {1,15}
OctLongLiteral    = 0+ 1? {OctDigit} {1,21} [lL]
OctDigit          = [0-7]
/* floats */
FloatLiteral  = ({Float1}|{Float2}|{Float3}) {Exponent}? [fF]
DoubleLiteral = ({Float1}|{Float2}|{Float3}) {Exponent}?

Float1    = [0-9]+ \. [0-9]*
Float2    = \. [0-9]+
Float3    = [0-9]+
Exponent = [eE] [+-]? [0-9]+

Marker = \" | \'
SingleMarker = \'
Other_Symbols = \*|\+|\[|\]|\!|\£|\$|\%|\&|\=|\?|\^|\-|\°|\#|\@|\:|\(|\)
Separators = \r|\n|\r\n\t\f
Letter = [a-zA-Z]
Letter_ = {Letter}|_
Alphanumerics_ = [ a-zA-Z0-9_]

StringLiteral = {Marker}   {StringContent}   {Marker}
StringContent =  {Alphanumerics_}*StringContent | {Other_Symbols}*StringContent | {Separators}*StringContent
CharLiteral = {SingleMarker} {CharContent} {SingleMarker}
CharContent = Alphanumerics| Other_Symbols
Comment = "/**" ( [^*] | \*+ [^/*] )* "*"+ "/"
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]

%state STRING, CHARLITERAL

%%

<YYINITIAL> {

  "d"							 { return symbol(sym.D);}
  "f"							 { return symbol(sym.F);}

  /* keywords */
  "abstract"                     { return symbol(sym.ABSTRACT); }
  "boolean"                      { return symbol(sym.BOOLEAN); }
  "break"                        { return symbol(sym.BREAK); }
  "byte"                         { return symbol(sym.BYTE); }
  "case"                         { return symbol(sym.CASE); }
  "catch"                        { return symbol(sym.CATCH); }
  "char"                         { return symbol(sym.CHAR); }
  "class"                        { return symbol(sym.CLASS); }
  "continue"                     { return symbol(sym.CONTINUE); }
  "default"                      { return symbol(sym.DEFAULT); }
  "do"                           { return symbol(sym.DO); }
  "double"                       { return symbol(sym.DOUBLE); }
  "else"                         { return symbol(sym.ELSE); }
  "extends"                      { return symbol(sym.EXTENDS); }
  "false"						 { return symbol(sym.FALSE);}
  "final"                        { return symbol(sym.FINAL); }
  "finally"                      { return symbol(sym.FINALLY); }
  "float"                        { return symbol(sym.FLOAT); }
  "for"                          { return symbol(sym.FOR); }
  "if"                           { return symbol(sym.IF); }
  "implements"                   { return symbol(sym.IMPLEMENTS); }
  "import"                       { return symbol(sym.IMPORT); }
  "instanceof"                   { return symbol(sym.INSTANCEOF); }
  "int"                          { return symbol(sym.INT); }
  "interface"                    { return symbol(sym.INTERFACE); }
  "long"                         { return symbol(sym.LONG); }
  "native"                       { return symbol(sym.NATIVE); }
  "new"                          { return symbol(sym.NEW); }
  "null"                         { return symbol(sym.NULL); }
  "package"                      { return symbol(sym.PACKAGE); }
  "private"                      { return symbol(sym.PRIVATE); }
  "protected"                    { return symbol(sym.PROTECTED); }
  "public"                       { return symbol(sym.PUBLIC); }
  "return"                       { return symbol(sym.RETURN); }
  "short"                        { return symbol(sym.SHORT); }
  "static"                       { return symbol(sym.STATIC); }
  "super"                        { return symbol(sym.SUPER); }
  "switch"                       { return symbol(sym.SWITCH); }
  "synchronized"                 { return symbol(sym.SYNCHRONIZED); }
  "this"                         { return symbol(sym.THIS); }
  "threadsafe"					 { return symbol(sym.THREADSAFE);}
  "throw"                        { return symbol(sym.THROW); }
  "transient"                    { return symbol(sym.TRANSIENT); }
  "true"						 { return symbol(sym.TRUE);}
  "try"                          { return symbol(sym.TRY); }
  "void"                         { return symbol(sym.VOID); }
  "while"                        { return symbol(sym.WHILE); }

/* Identifier*/
  {Identifier} 					 { return symbol(sym.IDENTIFIER,yytext());}

/* Float literals */
  {FloatLiteral} 				 { return symbol(sym.FLOATING_POINT_LITERAL, new String(yytext()));}

/* Integer literals */
  {DecIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL, new Integer(yytext())); }
  {DecLongLiteral}               { return symbol(sym.INTEGER_LITERAL, new Long(yytext().substring(0,yylength()-1))); }

  {HexIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL, new Integer((int) parseLong(2, yylength(), 16))); }
  {HexLongLiteral}               { return symbol(sym.INTEGER_LITERAL, new Long(parseLong(2, yylength()-1, 16))); }

  {OctIntegerLiteral}            { return symbol(sym.INTEGER_LITERAL, new Integer((int) parseLong(0, yylength(), 8))); }
  {OctLongLiteral}               { return symbol(sym.INTEGER_LITERAL, new Long(parseLong(0, yylength()-1, 8))); }

  {FloatLiteral}                 { return symbol(sym.FLOATING_POINT_LITERAL, new Float(yytext().substring(0,yylength()-1))); }
  {DoubleLiteral}                { return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext())); }
  {DoubleLiteral}[dD]            { return symbol(sym.FLOATING_POINT_LITERAL, new Double(yytext().substring(0,yylength()-1))); }

/* Comments*/
  {Comment}                      { /* just ignore it */ }

/* separators */
  "("                            { return symbol(sym.LPAREN); }
  ")"                            { return symbol(sym.RPAREN); }
  "{"                            { return symbol(sym.LBRACE); }
  "}"                            { return symbol(sym.RBRACE); }
  "["                            { return symbol(sym.LBRACK); }
  "]"                            { return symbol(sym.RBRACK); }
  ";"                            { return symbol(sym.SEMICOLON); }
  ":"                            { return symbol(sym.COLON); }
  ","                            { return symbol(sym.COMMA); }
  "."   		  		          		 { return symbol(sym.DOT); }
  "?"                            { return symbol(sym.QUESTION); }

  /* string literal */
    \"                             { yybegin(STRING); string.setLength(0); }

    /* character literal */
    \'                             { yybegin(CHARLITERAL); }
  /* White spaces */
  {WhiteSpace}					 { /* just ignore it*/}


/* arithmetical operators*/
  "+" 							 {return symbol(sym.PLUS);}
  "-" 							 {return symbol(sym.MINUS);}
  "*" 							 {return symbol(sym.MULT);}
  "/"						     {return symbol(sym.DIV);}
  "%"						     {return symbol(sym.MOD);}



/*unary operators*/
  "++"							 {return symbol(sym.AUTOINCRM);}
  "--"							 {return symbol(sym.AUTODECRM);}


/* assignment operators*/
 "="                             { return symbol(sym.ASSIGNMENT, new String(yytext())); }
 "-="                            { return symbol(sym.MINUSASSIGN, new String(yytext())); }
 "+="                            { return symbol(sym.PLUSASSIGN, new String(yytext())); }
 "*="                            { return symbol(sym.MULTASSIGN); }
 "/="                            { return symbol(sym.DIVASSIGN); }
 "%="                            { return symbol(sym.MODASSIGN); }
 "&="                            { return symbol(sym.ANDASSIGN); }
 "^="                            { return symbol(sym.XORASSIGN); }
 "|="                            { return symbol(sym.ORASSIGN); }
 ">>="                           { return symbol(sym.RSHIFTASSIGN, new String(yytext())); }
 "<<="                           { return symbol(sym.LSHIFTASSIGN, new String(yytext())); }


 /* Logical Operators*/
 "=="							 {return symbol(sym.EQEQ);}
 ">="							 {return symbol(sym.GTEQ);}
 "<="							 {return symbol(sym.LTEQ);}
 "<"							 {return symbol(sym.LT);}
 ">"							 {return symbol(sym.GT);}
 "||"							 {return symbol(sym.OROR);}
 "&&"							 {return symbol(sym.ANDAND);}
 "&"							 {return symbol(sym.AND);}
 "!"							 {return symbol(sym.NOT);}
 "!="							 {return symbol(sym.NOTEQ);}
 "|"							 {return symbol(sym.OR);}
 "^"						     {return symbol(sym.XOR);}
 ">>>"							 {return symbol(sym.URSHIFT);}
 "<<"							 {return symbol(sym.LSHIFT);}
 ">>"							 {return symbol(sym.RSHIFT);}
 "~"                             {return symbol(sym.NEG_BINARY);}



 /* check how to consider those later
  "x"							 { return symbol(sym.X);}
  "e"							 { return symbol(sym.E);}
  "l"							 { return symbol(sym.L);}

  {D}+{IS}?       { return symbol(sym.INTEGER, new String(yytext())); }
  */
  /* Input not matched */
  [^] { reportError(yyline+1, "Illegal character \"" + yytext() + "\""); }

 }

 <STRING> {
  \"                             { yybegin(YYINITIAL); return symbol(sym.STRING_LITERAL, string.toString()); }

  {StringCharacter}+             { string.append( yytext() ); }

  /* escape sequences */
  "\\b"                          { string.append( '\b' ); }
  "\\t"                          { string.append( '\t' ); }
  "\\n"                          { string.append( '\n' ); }
  "\\f"                          { string.append( '\f' ); }
  "\\r"                          { string.append( '\r' ); }
  "\\\""                         { string.append( '\"' ); }
  "\\'"                          { string.append( '\'' ); }
  "\\\\"                         { string.append( '\\' ); }
  \\[0-3]?{OctDigit}?{OctDigit}  { char val = (char) Integer.parseInt(yytext().substring(1),8);
                        				   string.append( val ); }

  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Unterminated string at end of line"); }
}

<CHARLITERAL> {
  {SingleCharacter}\'            { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character(yytext().charAt(0))); }

  /* escape sequences */
  "\\b"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\b'));}
  "\\t"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\t'));}
  "\\n"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\n'));}
  "\\f"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\f'));}
  "\\r"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\r'));}
  "\\\""\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\"'));}
  "\\'"\'                        { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\''));}
  "\\\\"\'                       { yybegin(YYINITIAL); return symbol(sym.CHARACTER_LITERAL, new Character('\\')); }
  \\[0-3]?{OctDigit}?{OctDigit}\' { yybegin(YYINITIAL);
			                              int val = Integer.parseInt(yytext().substring(1,yylength()-1),8);
			                            return symbol(sym.CHARACTER_LITERAL, new Character((char)val)); }

  /* error cases */
  \\.                            { throw new RuntimeException("Illegal escape sequence \""+yytext()+"\""); }
  {LineTerminator}               { throw new RuntimeException("Unterminated character literal at end of line"); }
}


%%
  [^] { throw new Error("Illegal character <"+yytext()+">"); }

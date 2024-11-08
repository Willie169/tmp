# ANTLR4
## Install
```
cd /data/data/com.termux/files/usr/lib
curl -O http://www.antlr.org/download/antlr-4.13.2-complete.jar
```
`.bashrc`:
```
export CLASSPATH=".:/data/data/com.termux/files/usr/lib/antlr-4.13.2-complete.jar:$CLASSPATH"
```
Check:
```
java -jar /data/data/com.termux/files/usr/lib/antlr-4.13.2-complete.jar
```
or
```
java org.antlr.v4.Tool
```
`.bashrc` recommended:
```
alias antlr4='java -jar /data/data/com.termux/files/usr/lib/antlr-4.13.2-complete.jar'
```
## Hello World
`Hello.g4`:
```
grammar Hello; // Define a grammar called Hello
r : 'hello' ID ; // match keyword hello followed by an identifier
ID : [a-z]+ ; // match lower-case identifiers
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines, \r (Windows)
```
```
antlr4 Hello.g4
```
```
~/antlr4 $ ls
Hello.g4
~/antlr4 $ antlr4 Hello.g4
~/antlr4 $ ls
Hello.g4      HelloBaseListener.java  HelloLexer.tokens
Hello.interp  HelloLexer.interp       HelloListener.java
Hello.tokens  HelloLexer.java         HelloParser.java
~/antlr4 $ javac *.java
~/antlr4 $ ls
 Hello.g4                  HelloLexer.java
 Hello.interp              HelloLexer.tokens
 Hello.tokens              HelloListener.class
 HelloBaseListener.class   HelloListener.java
 HelloBaseListener.java   'HelloParser$RContext.class'
 HelloLexer.class          HelloParser.class
 HelloLexer.interp         HelloParser.java
~/antlr4 $
```
## Test without Main
`.bashrc` recommended:
```
alias grun='java org.antlr.v4.runtime.misc.TestRig'
```
```
grun Hello r -tokens
hello parrt
<EOF> // Ctrl+D
```
```
~/antlr4 $ grun Hello r -tokens
Warning: TestRig moved to org.antlr.v4.gui.TestRig; calling automatically
hello parrt
[@0,0:4='hello',<'hello'>,1:0]
[@1,6:10='parrt',<ID>,1:6]
[@2,12:11='<EOF>',<EOF>,2:0]
~/antlr4 $
```
The computer will patiently wait for you to type in hello parrt followed by a newline. At that point, you must type the end-of-file character to terminate reading from standard input; otherwise, the program will stare at you for eternity. Once the recognizer has read all of the input, TestRig prints out the list of tokens per the use of option -tokens on grun.

We can print the parse tree in LISP-style text form (root children) just as easily.
```
grun Hello r -tree
hello parrt
<EOF>
```
```
~/antlr4 $ grun Hello r -tree
Warning: TestRig moved to org.antlr.v4.gui.TestRig; calling automatically
hello parrt
(r hello parrt)
~/antlr4 $
```
Running TestRig without any command-line options prints a small help message.
```
~/antlr4 $ grun
Warning: TestRig moved to org.antlr.v4.gui.TestRig; calling automatically
java org.antlr.v4.gui.TestRig GrammarName startRuleName
  [-tokens] [-tree] [-gui] [-ps file.ps] [-encoding encodingname]
  [-trace] [-diagnostics] [-SLL]
  [input-filename(s)]
Use startRuleName='tokens' if GrammarName is a lexer grammar.
Omitting input-filename makes rig read from stdin.
~/antlr4 $
```
## Start
`ArrayInit.g4`:
```
grammar ArrayInit;
init : '{' value (',' value)* '}' ;
value : init 
           | INT
           ;
INT : [0-9]+ ;
WS : [ \t\r\n]+ -> skip ;
```
Generate parser and lexer using antlr4 alias:
```
antlr4 ArrayInit.g4
```
Compile:
```
javac *.java
```
Test:
```
grun ArrayInit init -tokens
{99, 3, 451}
<EOF>
```
```
grun ArrayInit init -tree
{99, 3, 451}
<EOF>
```
```
~/antlr4 $ grun ArrayInit init -tokens
Warning: TestRig moved to org.antlr.v4.gui.TestRig; calling automatically
{99, 3, 451}
[@0,0:0='{',<'{'>,1:0]
[@1,1:2='99',<INT>,1:1]
[@2,3:3=',',<','>,1:3]
[@3,5:5='3',<INT>,1:5]
[@4,6:6=',',<','>,1:6]
[@5,8:10='451',<INT>,1:8]
[@6,11:11='}',<'}'>,1:11]
[@7,13:12='<EOF>',<EOF>,2:0]
~/antlr4 $ grun ArrayInit init -tree
Warning: TestRig moved to org.antlr.v4.gui.TestRig; calling automatically
{99, 3, 451}
(init { (value 99) , (value 3) , (value 451) })
```
```
grun ArrayInit init -gui
{1,{2,3},4}
<EOF>
```
### Listener
`ShortToUnicodeString.java`
```
/* Convert short array inits like {1, 2, 3} to "\u0001\u0002\u0003" */
public class ShortToUnicodeString extends ArrayInitBaseListener {
	@Override
	public void enterInit(ArrayInitParser.InitContext ctx) {
		System.out.print('"');
	}
	@Override
	public void exitInit(ArrayInitParser.InitContext ctx) {
		System.out.print('"');
	}
	@Override
	public void enterValue(ArrayInitParser.ValueContext ctx) {
		int value = Integer.valueOf(ctx.INT().getText());
		System.out.printf("\\u%04x", value);
    }
}
```
`Translate.java`:
```
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
public class Translate {
	public static void main(String[] args) throws Exception {
		ANTLRInputStream input = new ANTLRInputStream(System.in);
		ArrayInitLexer lexer = new ArrayInitLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		ArrayInitParser parser = new ArrayInitParser(tokens);
		ParseTree tree = parser.init();
		ParseTreeWalker walker = new ParseTreeWalker();
		walker.walk(new ShortToUnicodeString(), tree);
		System.out.println();
	}
}
```
```
javac ArrayInit*.java Translate.java
java Translate
{99, 3, 451}
<EOF>
```
```
~/antlr4 $ javac ArrayInit*.java Translate.java
Note: Translate.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
~/antlr4 $ java Translate
{99, 3, 451}
"\u0063\u0003\u01c3"
~/antlr4 $
```
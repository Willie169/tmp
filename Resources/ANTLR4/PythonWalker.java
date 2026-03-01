import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.FileInputStream;

public class PythonWalker {
	public static void main(String[] args) throws Exception {
		ANTLRInputStream input = new ANTLRInputStream(new FileInputStream(args[0]));
		PythonLexer lexer = new PythonLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		PythonParser parser = new PythonParser(tokens);
		ParseTree tree = parser.file_input();
		ParseTreeWalker walker = new ParseTreeWalker();
		walker.walk(new PythonParserBaseListener(), tree);
		System.out.println();
	}
}
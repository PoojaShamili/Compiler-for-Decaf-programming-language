# Compiler-for-Decaf-programming-language
The aim of the project was to write a compiler for a language called Decaf. Decaf is a simple language similar to C or Pascal.

The grammar for the language can be found in the file grammar.txt.

The project involves writing a parser for parsing the source code using flex and bison and detecting any errors, constructing the AST of the given source code by defining a custom class for each type of node, generating IR code from each of the nodes in the AST and then evaluating this IR using LLVM. The implementation till now has been done till constructing the AST of the code given.

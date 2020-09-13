# Minijava compiler for arm cortex-A

#### Uses yacc and lex for tokenization and grammar construction.

#### Generates instruction file intended for assembly on raspberry pi b+

#### Includes interpreter for real-time code execution

#### Directions (Linux):
 - run `make` in project subdirectory (parser, interpreter or compiler)
 - run generated executable and supply minijava instruction file (does not check file extension)
 - in case of compiler, .s file is generated to be assembled on pi (with gcc)

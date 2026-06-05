# Multi-language implementations of Conway's Game of Life

This project contains nearly identical implementations of Conway's Game of Life in multiple programming languages to showcase core language constructs for comparison purposes.

When creating a new implementation or making changes to an existing implementation:

1. Stick as closely as possible to the structure and canonical identifier names (see IMPLEMENTATION.md) used in the other implementations for consistency, adapting identifier casing per rule 2.
2. Naming follows each language's dominant community convention (official style guide or de-facto standard). Where the language has no clear convention, default to:
   - Variable and function names in snake_case
   - Class names in PascalCase
   - Constants in SCREAMING_SNAKE_CASE
3. Unless a language requires otherwise to compile/run, indentation uses two spaces.
4. Do not create any documentation or summary files other than README.md.
5. Keep README.md minimal, with only essential instructions to install dependencies and run the implementation.

When asked for suggestions for improving an implementation's performance:

1. World cells must remain as a HashMap with string keys. Do not suggest otherwise!
2. Only suggest things that can be applied to other implementations (i.e. nothing language-specific).

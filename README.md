# Multi-language implementations of Conway's Game of Life

This project contains nearly identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" in multiple programming languages to showcase core language constructs for comparison purposes.

Each implementation is as identical in file structure, class/variable naming, and overall layout as possible to make comparison easier. As far as possible, no external dependencies are used, so that only the core language features are demonstrated.

Each language's developer community may prefer different code styles (spaces vs tabs, snake_case vs camelCase, etc). For consistency and the easiest comparison, unless a language requires otherwise to compile/run, indentation uses two spaces, variable and function names are snake_case, class names are PascalCase, and constants are SCREAMING_SNAKE_CASE.

## Core Language Constructs

- Dynamic vs Static Typing
- Variable Declaration/Assignment
- Method/Function Definitions (including parameters/return types)
- Class/Struct Definitions (including public/private class/instance methods/variables)
- Storage Structures (Arrays/Lists, Hashes/Maps)
- Conditional Statements (if, else if, else)
- Loops (for, foreach, while)
- String Concatenation
- Error Handling / Custom Exceptions
- Benchmarking (high-res where possible)
- Printing to stdout
- Comments

## Feature Comparison

**Note:** The lists below are not exhaustive, but include core things found in various languages. As expected, languages evolve over time, so if a language has added a feature marked with ✖ below, please open a ticket and let me know so I can take a look/update accordingly.

[![Feature Comparison Spreadsheet](/features.png)](https://docs.google.com/spreadsheets/d/1XF2xgN_T3FIeFjJ4iqM1NvcvMG6Zz3ytyJXbvEDVb-U/edit?usp=sharing#gid=0)

## Speed Results (by # iterations in 30 seconds)

**Note:** Because the implementations are as similar as possible, the runtime of some implementations may not run as fast as they could be if native/optimized functions were used. Additionally, there are certainly faster ways in general to write these implementations, e.g. using a 2D array for all cells. However, the primary purpose of these implementations is to demonstrate as wide a range of common syntax as possible between languages. Therefore, I will not be accepting pull requests that rewrite how an implementation works if it removes a key syntax feature demonstration in the process.

**Note:** These speed results are taken on a MacBook Pro 16" (Nov 2023), Apple M3 Pro, with 18 GB of RAM. The times (measured in milliseconds) were calculated by playing each simulation for 30 seconds (using `benchmark.sh` in each implementation), and recording the fastest result. The table below is sorted by number of iterations that were completed within the 30 seconds. Iterations take into account aspects such as garbage collection and other overhead that are not necessarily measured by the tick and render values. This can result in some implementations with faster combined averages being ranked lower because of greater overhead.

[![Speed Results Spreadsheet](/results.png)](https://docs.google.com/spreadsheets/d/1XF2xgN_T3FIeFjJ4iqM1NvcvMG6Zz3ytyJXbvEDVb-U/edit?usp=sharing#gid=1866601212)

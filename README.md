# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get an idea of the syntax differences and a rough runtime speed of each language with a common implementation (i.e. not using specific optimizations that exist only for one language).

All implementations are coded as similarly as possible using features available in the core language (no external dependencies unless necessary). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). They use OOP features where possible (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility, etc) or structs/objects for languages that do not support OOP natively (e.g. Go).

## Feature Comparison

**Note:** The lists below are not exhaustive, but include core things found in various languages. As expected, languages evolve over time, so if a language has added a feature marked with ✖ below, please open a ticket and let me know, so I can take a look/update accordingly.

[![Feature Comparison Spreadsheet](/features.png)](https://docs.google.com/spreadsheets/d/1XF2xgN_T3FIeFjJ4iqM1NvcvMG6Zz3ytyJXbvEDVb-U/edit?usp=sharing#gid=0)

## Speed Results (by # iterations in 30 seconds)

**Note:** Because the implementations are as similar as possible, the runtime of some implementations may not run as fast as they could be if native/optimized functions were used. Additionally, there are certainly faster ways in general to write these implementations, e.g. using a 2D array for all cells. However, the primary purpose of these implementations is to demonstrate as wide a range of common syntax as possible between languages. Therefore, I will not be accepting pull requests that rewrite how an implementation works if it removes a key syntax feature demonstration in the process.

**Note:** These speed results are taken on a Macbook Pro 16" (Nov 2023), Apple M3 Pro, with 18 GB of RAM. The times (measured in milliseconds) were calculated by playing each simulation for 30 seconds (using `benchmark.sh` in each implementation), and recording the ending results. The table below is sorted by number of iterations that were completed within the 30 seconds. Iterations takes into account aspects such as garbage collection and other overhead that are not necessarily measured by the tick and render values. This can result in some implementations with faster combined averages being ranked lower because of greater overhead.

[![Speed Results Spreadsheet](/results.png)](https://docs.google.com/spreadsheets/d/1XF2xgN_T3FIeFjJ4iqM1NvcvMG6Zz3ytyJXbvEDVb-U/edit?usp=sharing#gid=1866601212)

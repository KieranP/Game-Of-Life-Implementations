# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get an idea of the syntax differences and a rough runtime speed of each language with a common implementation (i.e. not using specific optimizations that exist only for one language).

All implementations are coded as similarly as possible using features available in the core language (no external dependencies unless necessary). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). They use OOP features where possible (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility, etc) or structs/objects for languages that do not support OOP natively (e.g. Go).

## Feature Comparison

**Note:** The lists below are not exhaustive, but include core things found in various languages. As expected, languages evolve over time, so if a language has added a feature marked with ✖ below, please open a ticket and let me know, so I can take a look/update accordingly.

![Feature Comparison Spreadsheet](/features.png)

## Speed Results (by # iterations in 30 seconds)

**Note:** Because the implementations are as similar as possible, the runtime of some implementations may not run as fast as they could be if native/optimized functions were used. Additionally, there are certainly faster ways in general to write these implementations, e.g. using a 2D array for all cells. However, the primary purpose of these implementations is to demonstrate as wide a range of common syntax as possible between languages. Therefore, I will not be accepting pull requests that rewrite how an implementation works if it removes a key syntax feature demonstration in the process.

**Note:** These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM. The times were calculated by playing each simulation for 30 seconds (using `timeout 30 [command]`), and recording the ending results. The table below is sorted by number of iterations that were completed within the 30 seconds. Iterations takes into account aspects such as garbage collection and other overhead that are not necessarily measured by the tick and render values. This can result in some implementations with faster combined averages being ranked lower because of greater overhead.

| Place | Language   | Iterations | Combined Lowest | Combined Avg | Tick Lowest | Tick Avg | Render Lowest | Render Avg | Typed   | Execution   | Interpreter/Runtime        |
| :---- | :--------- | :--------: | :-------------: | :----------: | :---------: | :------: | :-----------: | :--------: | :------ | :---------- | :------------------------- |
| 1st.  | Java       |   28568    |     0.437ms     |   0.492ms    |   0.198ms   | 0.229ms  |    0.239ms    |  0.263ms   | Static  | Interpreted | JRE 21.0.1                 |
| 2nd.  | Kotlin     |   28479    |     0.417ms     |   0.480ms    |   0.215ms   | 0.255ms  |    0.202ms    |  0.225ms   | Static  | Interpreted | Kotlin 1.9.255 (JRE 21)    |
| 3rd.  | C#         |   26272    |     0.571ms     |   0.658ms    |   0.082ms   | 0.109ms  |    0.489ms    |  0.549ms   | Static  | Native      | DotNet 8.0.100             |
| 4th.  | Go         |   24378    |     0.641ms     |   0.697ms    |   0.199ms   | 0.228ms  |    0.442ms    |  0.469ms   | Static  | Native      | Golang 1.21.4              |
| 5th.  | Typescript |   23647    |     0.655ms     |   0.729ms    |   0.162ms   | 0.197ms  |    0.493ms    |  0.532ms   | Static  | Interpreted | Deno 1.37.2                |
| 6th.  | Typescript |   23336    |     0.664ms     |   0.763ms    |   0.158ms   | 0.221ms  |    0.506ms    |  0.542ms   | Static  | Interpreted | Node 21.2.0                |
| 7th.  | Dart       |   22369    |     0.758ms     |   0.824ms    |   0.143ms   | 0.166ms  |    0.615ms    |  0.658ms   | Static  | Native      | Dart 3.1.5                 |
| 8th.  | Scala      |   22104    |     0.675ms     |   0.768ms    |   0.408ms   | 0.476ms  |    0.267ms    |  0.292ms   | Static  | Interpreted | Scala 3.3.1 (JRE 21.0.1)   |
| 9th.  | Typescript |   21494    |     0.797ms     |   0.881ms    |   0.175ms   | 0.192ms  |    0.622ms    |  0.689ms   | Static  | Interpreted | Bun 0.5.9                  |
| 10th. | Lua        |   20150    |     0.813ms     |   0.964ms    |   0.404ms   | 0.500ms  |    0.409ms    |  0.464ms   | Dynamic | Interpreted | LuaJIT 2.1.1               |
| 11th. | C++        |   19836    |     0.936ms     |   1.013ms    |   0.387ms   | 0.423ms  |    0.549ms    |  0.590ms   | Static  | Native      | Clang 15.0.0               |
| 12th. | Odin       |   19589    |     0.870ms     |   0.977ms    |   0.134ms   | 0.159ms  |    0.736ms    |  0.818ms   | Static  | Native      | Odin dev-2023-11           |
| 13th. | Crystal    |   18133    |     0.775ms     |   1.099ms    |   0.079ms   | 0.108ms  |    0.696ms    |  0.991ms   | Static  | Native      | Crystal 1.10.1             |
| 14th. | Python     |   16525    |     0.882ms     |   1.202ms    |   0.437ms   | 0.587ms  |    0.445ms    |  0.615ms   | Dynamic | Interpreted | PyPy 7.3.13                |
| 15th. | D          |   14179    |     1.391ms     |   1.569ms    |   0.143ms   | 0.172ms  |    1.248ms    |  1.397ms   | Static  | Native      | DLang 2.105.2 (LDC 1.35.0) |
| 16th. | V          |   13466    |     1.514ms     |   1.696ms    |   0.130ms   | 0.157ms  |    1.384ms    |  1.539ms   | Static  | Native      | Vlang 0.4.3                |
| 17th. | Pony       |   12829    |     1.006ms     |   1.163ms    |   0.311ms   | 0.369ms  |    0.695ms    |  0.794ms   | Static  | Native      | Pony 0.57.1                |
| 18th. | PHP        |   12809    |     1.599ms     |   1.735ms    |   0.426ms   | 0.502ms  |    1.173ms    |  1.233ms   | Dynamic | Interpreted | PHP 8.2.12 (w/JIT)         |
| 19th. | Ruby       |   12546    |     1.257ms     |   1.732ms    |   0.385ms   | 0.545ms  |    0.872ms    |  1.187ms   | Dynamic | Interpreted | TruffleRuby 23.0.0         |
| 20th. | Swift      |   11834    |     1.845ms     |   1.972ms    |   0.900ms   | 0.967ms  |    0.945ms    |  1.005ms   | Static  | Native      | Swift 5.9.0                |
| 21st. | Nim        |   11467    |     1.815ms     |   2.032ms    |   0.993ms   | 1.078ms  |    0.882ms    |  0.954ms   | Static  | Native      | Nim 2.0.0                  |
| 22nd. | D          |    9048    |     2.564ms     |   2.770ms    |   0.268ms   | 0.318ms  |    2.296ms    |  2.452ms   | Static  | Native      | DLang 2.105.3 (DMD)        |
| 23rd. | PHP        |    7164    |     3.355ms     |   3.605ms    |   1.719ms   | 1.844ms  |    1.636ms    |  1.761ms   | Dynamic | Interpreted | PHP 8.2.12                 |
| 24th. | Groovy     |    7006    |     2.972ms     |   3.317ms    |   0.483ms   | 0.619ms  |    2.489ms    |  2.698ms   | Static  | Interpreted | Groovy 4.0.15 (JRE 21.0.1) |
| 25th. | Python     |    5532    |     4.536ms     |   4.814ms    |   2.040ms   | 2.149ms  |    2.496ms    |  2.665ms   | Dynamic | Interpreted | Python 3.11.6              |
| 26th. | Ruby       |    4264    |     5.903ms     |   6.360ms    |   3.358ms   | 3.594ms  |    2.545ms    |  2.766ms   | Dynamic | Interpreted | CRuby 3.2.2 (w/JIT)        |
| 27th. | Lua        |    4021    |     6.428ms     |   6.823ms    |   3.810ms   | 4.095ms  |    2.618ms    |  2.728ms   | Dynamic | Interpreted | Lua 5.4.6                  |
| 28th. | Ruby       |    3959    |     6.079ms     |   6.878ms    |   3.626ms   | 3.959ms  |    2.453ms    |  2.919ms   | Dynamic | Interpreted | CRuby 3.2.2                |
| 29th. | Ruby       |    3918    |     5.533ms     |   6.342ms    |   3.842ms   | 4.350ms  |    1.691ms    |  1.992ms   | Dynamic | Interpreted | JRuby 9.4.3.0 (JRE 21.0.1) |
| 30th. | Perl       |    2245    |    11.526ms     |   12.682ms   |   7.816ms   | 8.665ms  |    3.710ms    |  4.017ms   | Dynamic | Interpreted | Perl 5.38.0                |
| 31st. | Elixir     |    1138    |    18.574ms     |   23.345ms   |  15.786ms   | 19.819ms |    2.788ms    |  3.526ms   | Dynamic | Interpreted | Elixir 1.15.7              |

# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get an idea of the syntax differences and a rough runtime speed of each language with a common implementation (i.e. not using specific optimizations that exist only for one language).

All implementations are coded as similarly as possible using features available in the core language (no external dependencies unless necessary). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). They use OOP features where possible (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility, etc) or structs/objects for languages that do not support OOP natively (e.g. Go).

## Feature Comparison

**Note:** The lists below are not exhaustive, but include core things found in various languages. As expected, languages evolve over time, so if a language has added a feature marked with ✖ below, please open a ticket and let me know, so I can take a look/update accordingly.

![Feature Comparison Spreadsheet](/features.png)

## Speed Results (by tick time)

**Note:** Because the implementations are as similar as possible, the runtime of some implementations may not run as fast as they could be if native/optimized functions were used. Additionally, there are certainly faster ways in general to write these implementations, e.g. using a 2D array for all cells. However, the primary purpose of these implementations is to demonstrate as wide a range of common syntax as possible between languages. Therefore, I will not be accepting pull requests that rewrite how an implementation works if it removes a key syntax feature demonstration in the process.

**Note:** These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM. The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 30s), and then grabbing the averages.

| Place | Language   | Tick Lowest | Tick Avg | Render Lowest | Render Avg | Typed   | Execution   | Interpreter/Runtime        |
| :---- | :--------- | :---------: | :------: | :-----------: | :--------: | :------ | :---------- | :------------------------- |
| 1st.  | Crystal    |   0.075ms   | 0.102ms  |    0.690ms    |  0.996ms   | Static  | Native      | Crystal 1.9.2              |
| 2nd.  | C#         |   0.116ms   | 0.142ms  |    0.559ms    |  0.606ms   | Static  | Native      | DotNet 7.0.401             |
| 3rd.  | V          |   0.133ms   | 0.153ms  |    1.396ms    |  1.562ms   | Static  | Native      | Vlang 0.4.2                |
| 4th.  | Dart       |   0.144ms   | 0.168ms  |    0.615ms    |  0.660ms   | Static  | Native      | Dart 3.1.3                 |
| 5th.  | D          |   0.147ms   | 0.170ms  |    1.252ms    |  1.365ms   | Static  | Native      | DLang 2.104.2 (LDC 1.34.0) |
| 6th.  | Typescript |   0.159ms   | 0.192ms  |    0.480ms    |  0.526ms   | Static  | Interpreted | Node 20.5.1                |
| 7th.  | Typescript |   0.162ms   | 0.197ms  |    0.493ms    |  0.532ms   | Static  | Interpreted | Deno 1.37.1                |
| 8th.  | Odin       |   0.167ms   | 0.192ms  |    1.259ms    |  1.344ms   | Static  | Native      | Odin dev-2023-10           |
| 9th.  | Typescript |   0.174ms   | 0.190ms  |    0.621ms    |  0.679ms   | Static  | Interpreted | Bun 0.5.9                  |
| 10th. | Go         |   0.203ms   | 0.229ms  |    0.441ms    |  0.469ms   | Static  | Native      | Golang 1.21.1              |
| 11th. | Kotlin     |   0.221ms   | 0.262ms  |    0.216ms    |  0.243ms   | Static  | Interpreted | Kotlin 1.9.10 (JRE 21)     |
| 12th. | Java       |   0.242ms   | 0.275ms  |    0.242ms    |  0.274ms   | Static  | Interpreted | JRE 20                     |
| 13th. | D          |   0.284ms   | 0.311ms  |    2.176ms    |  2.394ms   | Static  | Native      | DLang 2.105.1 (DMD)        |
| 14th. | Pony       |   0.306ms   | 0.341ms  |    0.705ms    |  0.773ms   | Static  | Native      | Pony 0.56.2                |
| 15th. | C++        |   0.380ms   | 0.427ms  |    0.539ms    |  0.587ms   | Static  | Native      | Clang 15.0.0               |
| 16th. | Ruby       |   0.380ms   | 0.551ms  |    0.868ms    |  1.231ms   | Dynamic | Interpreted | TruffleRuby 23.0.0         |
| 17th. | Scala      |   0.408ms   | 0.479ms  |    0.293ms    |  0.330ms   | Static  | Interpreted | Scala 3.3.1 (JRE 21)       |
| 18th. | Python     |   0.408ms   | 0.512ms  |    0.460ms    |  0.605ms   | Dynamic | Interpreted | PyPy 7.3.12                |
| 19th. | Lua        |   0.418ms   | 0.501ms  |    0.409ms    |  0.468ms   | Dynamic | Interpreted | LuaJIT 2.1.0-beta3         |
| 20th. | PHP        |   0.421ms   | 0.465ms  |    1.137ms    |  1.188ms   | Dynamic | Interpreted | PHP 8.2.11 (w/JIT)         |
| 21st. | Groovy     |   0.470ms   | 0.569ms  |    2.494ms    |  2.656ms   | Static  | Interpreted | Groovy 4.0.15 (JRE 21)     |
| 22nd. | Swift      |   0.900ms   | 0.955ms  |    0.942ms    |  1.005ms   | Static  | Native      | Swift 5.9                  |
| 23rd. | Nim        |   0.998ms   | 1.067ms  |    0.888ms    |  0.958ms   | Static  | Native      | Nim 2.0.0                  |
| 24th. | PHP        |   1.688ms   | 1.826ms  |    1.575ms    |  1.679ms   | Dynamic | Interpreted | PHP 8.2.11                 |
| 25th. | Python     |   2.006ms   | 2.126ms  |    2.484ms    |  2.660ms   | Dynamic | Interpreted | Python 3.11.5              |
| 26th. | Ruby       |   3.376ms   | 3.612ms  |    2.525ms    |  2.776ms   | Dynamic | Interpreted | CRuby 3.2.2 (w/JIT)        |
| 27th. | Ruby       |   3.716ms   | 4.083ms  |    2.565ms    |  2.977ms   | Dynamic | Interpreted | CRuby 3.2.2                |
| 28th. | Ruby       |   3.854ms   | 4.302ms  |    1.740ms    |  1.972ms   | Dynamic | Interpreted | JRuby 9.4.1.0 (JRE 20)     |
| 29th. | Lua        |   3.958ms   | 4.123ms  |    2.549ms    |  2.665ms   | Dynamic | Interpreted | Lua 5.4.6                  |
| 30th. | Perl       |   7.985ms   | 8.888ms  |    3.795ms    |  4.018ms   | Dynamic | Interpreted | Perl 5.38.0                |
| 31st. | Elixir     |  15.844ms   | 19.819ms |    2.788ms    |  3.526ms   | Dynamic | Interpreted | Elixir 1.15.6              |

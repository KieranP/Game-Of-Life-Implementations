# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get an idea of the syntax differences and a rough runtime speed of each language with a common implementation (i.e. not using specific optimizations that exist only for one language).

All implementations are coded as similarly as possible using features available in the core language (no external dependencies unless necessary). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). They use OOP features where possible (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility, etc) or structs/objects for languages that do not support OOP natively (e.g. Go).

## Feature Comparison

**Note:** The lists below are not exhaustive, but include core things found in various languages. As expected, languages evolve over time, so if a language has added a feature marked with ✖ below, please open a ticket and let me know, so I can take a look/update accordingly.

![Feature Comparison Spreadsheet](/features.png)

## Speed Results (by tick time)

**Note:** Because the implementations are as similar as possible, the runtime of some implementations may not run as fast as they could be if native/optimized functions were used. Additionally, there are certainly faster ways in general to write these implementations, e.g. using a 2D array for all cells. However, the primary purpose of these implementations is to demonstrate as wide a range of common syntax as possible between languages. Therefore, I will not be accepting pull requests that rewrite how an implementation works if it removes a key syntax feature demonstration in the process.

**Note:** These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM. The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 30s), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg | Typed   | Execution   | Interpreter/Runtime        |
| :---- | :--------- | :------: | :--------: | :------ | :---------- | :------------------------- |
| 1st.  | Crystal    | 0.102ms  |  0.956ms   | Static  | Native      | Crystal 1.7.2              |
| 2nd.  | Dart       | 0.154ms  |  0.615ms   | Static  | Native      | Dart 3.0.0                 |
| 3rd.  | Typescript | 0.159ms  |  0.699ms   | Static  | Interpreted | Bun 0.5.6                  |
| 4th.  | Typescript | 0.161ms  |  0.514ms   | Static  | Interpreted | Deno 1.31.1                |
| 5th.  | V          | 0.166ms  |  1.554ms   | Static  | Native      | Vlang 0.3.3                |
| 6th.  | D          | 0.167ms  |  1.165ms   | Static  | Native      | DLang 2.102.2 (LDC 1.32.0) |
| 7th.  | Typescript | 0.172ms  |  0.526ms   | Static  | Interpreted | Node 19.6.1                |
| 8th.  | Odin       | 0.196ms  |  1.364ms   | Static  | Native      | Odin dev-2023-08           |
| 9th.  | Go         | 0.224ms  |  0.464ms   | Static  | Native      | Golang 1.20.7              |
| 10th. | Javascript | 0.226ms  |  1.082ms   | Dynamic | Interpreted | Chromium 110               |
| 11th. | Java       | 0.276ms  |  0.272ms   | Static  | Interpreted | JRE 20                     |
| 12th. | Kotlin     | 0.293ms  |  0.270ms   | Static  | Interpreted | Kotlin 1.8.21 (JRE 20)     |
| 13th. | C#         | 0.298ms  |  1.847ms   | Static  | Interpreted | Mono 6.12.0.182            |
| 14th. | D          | 0.298ms  |  2.565ms   | Static  | Native      | DLang 2.103.0 (DMD)        |
| 15th. | C++        | 0.420ms  |  0.591ms   | Static  | Native      | Clang 14.0.3               |
| 16th. | PHP        | 0.463ms  |  1.126ms   | Dynamic | Interpreted | PHP 8.2.5 (w/JIT)          |
| 17th. | Scala      | 0.503ms  |  0.331ms   | Static  | Interpreted | Scala 3.2.2 (JRE 20)       |
| 18th. | Python     | 0.578ms  |  0.683ms   | Dynamic | Interpreted | PyPy 7.3.9                 |
| 19th. | Groovy     | 0.586ms  |  2.528ms   | Static  | Interpreted | Groovy 4.0.11 (JRE 20)     |
| 20th. | Ruby       | 0.694ms  |  1.873ms   | Dynamic | Interpreted | TruffleRuby 22.3.1         |
| 21st. | Javascript | 0.775ms  |  1.295ms   | Dynamic | Interpreted | Firefox 110.0              |
| 22nd. | Lua        | 0.927ms  |  1.018ms   | Dynamic | Interpreted | LuaJIT 2.1.0-beta3         |
| 23rd. | Nim        | 0.980ms  |  1.301ms   | Static  | Native      | Nim 1.6.12                 |
| 24th. | Swift      | 1.040ms  |  1.543ms   | Static  | Native      | Swift 5.8.0                |
| 25th. | PHP        | 1.786ms  |  1.583ms   | Dynamic | Interpreted | PHP 8.2.5                  |
| 26th. | Python     | 2.261ms  |  2.813ms   | Dynamic | Interpreted | Python 3.11.2              |
| 27th. | Ruby       | 3.430ms  |  2.586ms   | Dynamic | Interpreted | CRuby 3.2.1 (w/JIT)        |
| 28th. | Ruby       | 3.862ms  |  2.906ms   | Dynamic | Interpreted | CRuby 3.2.1                |
| 29th. | Lua        | 4.123ms  |  2.665ms   | Dynamic | Interpreted | Lua 5.4.4                  |
| 30th. | Ruby       | 4.246ms  |  1.938ms   | Dynamic | Interpreted | JRuby 9.4.1.0 (JRE 20)     |
| 31st. | Perl       | 8.330ms  |  3.530ms   | Dynamic | Interpreted | Perl 5.36.0                |

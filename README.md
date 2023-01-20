# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get an idea of the syntax differences and a rough runtime speed of each language with a common implementation (i.e. not using specific optimizations that exist only for one language).

All implementations are coded as similarly as possible using features available in the core language (no external dependencies unless necessary). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). They use OOP features where possible (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility, etc) or structs/objects for languages that do not support OOP natively (e.g. Go).

## Feature Comparison

**Note:** The lists below are not exhaustive, but include core things found in various languages.

### Static Typed Languages

| Feature                          | C#  | Crystal | Dart | Go  | Groovy | Java | Kotlin | Nim | Scala | Swift | TypeScript |
| :------------------------------- | :-: | :-----: | :--: | :-: | :----: | :--: | :----: | :-: | :---: | :---: | :--------: |
| Classes/Objects (Top Level)      |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Classes/Objects (Nested)         |  ✔  |    ✔    |  ✖   |  ✖  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✖   |     ✔      |
| Class/Object Initializer         |  ✔  |    ✔    |  ✔   |  ✖  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✔   |     ✔      |
| Class/Object Methods             |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✔   |     ✔      |
| Class/Object Method Visibility   |  ✔  |    ✔    |  ✔   |  ▵  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✔   |     ✔      |
| Class/Object Variables           |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✖   |     ✔      |
| Class/Object Variable Visibility |  ✔  |    ✔    |  ✔   |  ▵  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✖   |     ✔      |
| Instance Methods                 |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Instance Method Visibility       |  ✔  |    ✔    |  ✔   |  ▵  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Instance Variables               |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Instance Variable Visibility     |  ✔  |    ✔    |  ✔   |  ▵  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Named Parameters/Arguments       |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✖   |   ✔    |  ✖  |   ✔   |   ✔   |     ✖      |
| Default Parameters/Arguments     |  ✔  |    ✔    |  ✔   |  ✖  |   ✔    |  ✖   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| semicolon optional               |  ✖  |    ✔    |  ✖   |  ✔  |   ✔    |  ✖   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| return keyword optional          |  ✖  |    ✔    |  ✖   |  ✖  |   ✔    |  ✖   |   ✖    |  ✔  |   ✔   |   ✖   |     ✖      |
| Looping over Array (value)       |  ✔  |    ✔    |  ✔   |  ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Looping over Hash (key/value)    |  ✔  |    ✔    |  ✔   |  ✔  |   ✖    |  ✖   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Custom Exceptions                |  ✔  |    ✔    |  ✔   |  ✖  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Exceptions Must Be Caught        |  ✖  |    ✖    |  ✖   |  ✖  |   ✖    |  ✔   |   ✖    |  ✖  |   ✖   |   ✔   |     ✖      |

▵ visibility for package, not for object scope.

### Dynamic Typed Languages

| Feature                          | Javascript | Lua | Perl | PHP | Python | Ruby |
| :------------------------------- | :--------: | :-: | :--: | :-: | :----: | :--: |
| Classes/Objects (Top Level)      |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Classes/Objects (Nested)         |     ✔      |  ✔  |  ✖   |  ✖  |   ✔    |  ✔   |
| Class/Object Initializer         |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Class/Object Methods             |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Class/Object Method Visibility   |     ✖      |  ✖  |  ✖   |  ✔  |   ✖    |  ✔   |
| Class/Object Variables           |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Class/Object Variable Visibility |     ✖      |  ✖  |  ✖   |  ✔  |   ✖    |  ✔   |
| Instance Methods                 |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Instance Method Visibility       |     ✖      |  ✖  |  ✖   |  ✔  |   ✖    |  ✔   |
| Instance Variables               |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Instance Variable Visibility     |     ✖      |  ✖  |  ✖   |  ✔  |   ✖    |  ✔   |
| Named Parameters/Arguments       |     ✖      |  ✖  |  ✖   |  ✖  |   ✖    |  ✔   |
| Default Parameters/Arguments     |     ✔      |  ✖  |  ✔   |  ✔  |   ✔    |  ✔   |
| semicolon optional               |     ✔      |  ✔  |  ✖   |  ✖  |   ✔    |  ✔   |
| return keyword optional          |     ✖      |  ✖  |  ✔   |  ✖  |   ✖    |  ✔   |
| Looping over Array (value)       |     ✔      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Looping over Hash (key/value)    |     ✖      |  ✔  |  ✔   |  ✔  |   ✔    |  ✔   |
| Custom Exceptions                |     ✔      |  ✔  |  ✖   |  ✔  |   ✔    |  ✔   |
| Exceptions Must Be Caught        |     ✖      |  ✖  |  ✖   |  ✖  |   ✖    |  ✖   |

## Speed Results (by tick time)

**Note:** Because the implementations are as similar as possible, the runtime of some implementations may not run as fast as they could be if native/optimized functions were used. Additionally, there are certainly faster ways in general to write these implementations, e.g. using a 2D array for all cells. However, the primary purpose of these implementations is to demonstrate as wide a range of common syntax as possible between languages. Therefore, I will not be accepting pull requests that rewrite how an implementation works if it removes a key syntax feature demonstration in the process.

**Note:** These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM. The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 30s), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes                            |
| :---- | :--------- | :------: | :--------: | :-----: | :------------------------------- |
| 1st.  | Crystal    | 0.102ms  |  0.857ms   | Static  | Crystal 1.4.1                    |
| 2nd.  | Dart       | 0.169ms  |  0.564ms   | Static  | Dart 2.17.3                      |
| 3rd.  | Go         | 0.233ms  |  0.486ms   | Static  | Golang 1.18.3                    |
| 4th.  | Kotlin     | 0.292ms  |  0.267ms   | Static  | Kotlin 1.6.21 (OpenJDK 18.0.1.1) |
| 5th.  | C#         | 0.299ms  |  1.878ms   | Static  | Mono 6.12.0.122                  |
| 6th.  | Java       | 0.305ms  |  0.271ms   | Static  | OpenJDK 18.0.1.1                 |
| 6th.  | Typescript | 0.345ms  |  0.765ms   | Static  | Bun 0.4.0                        |
| 7th.  | Scala      | 0.536ms  |  0.334ms   | Static  | Scala 2.13.8 (OpenJDK 18.0.1.1)  |
| 8th.  | Javascript | 0.678ms  |  1.343ms   | Dynamic | Firefox 101.0                    |
| 9th.  | Groovy     | 0.781ms  |  2.934ms   | Static  | Groovy 4.0.2 (OpenJDK 18.0.1.1)  |
| 10th. | Nim        | 1.062ms  |  1.318ms   | Static  | Nim 1.6.6                        |
| 11th. | Ruby       | 1.082ms  |  5.206ms   | Dynamic | TruffleRuby 22.1.0               |
| 12th. | Javascript | 1.402ms  |  1.242ms   | Dynamic | Chromium 102                     |
| 13th. | Swift      | 1.410ms  |  1.605ms   | Static  | Swift 5.6.1                      |
| 14th. | Typescript | 1.591ms  |  0.664ms   | Static  | Deno 1.22.0                      |
| 15th. | PHP        | 1.872ms  |  1.663ms   | Dynamic | PHP 8.1.6                        |
| 16th. | Javascript | 2.151ms  |  0.881ms   | Static  | Node 18.2.0                      |
| 17th. | Ruby       | 3.953ms  |  2.242ms   | Dynamic | JRuby 9.3.4.0                    |
| 18th. | Ruby       | 4.016ms  |  3.045ms   | Dynamic | CRuby 3.1.2                      |
| 19th. | Python     | 4.086ms  |  3.980ms   | Dynamic | Python 3.9.13                    |
| 20th. | Lua        | 4.191ms  |  2.724ms   | Dynamic | Lua 5.4.4                        |
| 21st. | Perl       | 10.689ms |  4.349ms   | Dynamic | Perl 5.34.0                      |

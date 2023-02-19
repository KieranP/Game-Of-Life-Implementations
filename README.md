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

| Place | Language   | Tick Avg | Render Avg |  Typed  | Interpreter/Runtime        |
| :---- | :--------- | :------: | :--------: | :-----: | :------------------------- |
| 1st.  | Crystal    | 0.102ms  |  0.956ms   | Static  | Crystal 1.7.2              |
| 2nd.  | Typescript | 0.159ms  |  0.699ms   | Static  | Bun 0.5.6                  |
| 3rd.  | Typescript | 0.172ms  |  0.526ms   | Static  | Node 19.6.1                |
| 4th.  | Typescript | 0.177ms  |  0.491ms   | Static  | Deno 1.30.3                |
| 5th.  | Dart       | 0.181ms  |  0.562ms   | Static  | Dart 2.19.0                |
| 6th.  | Javascript | 0.226ms  |  1.082ms   | Dynamic | Chromium 110               |
| 7th.  | Go         | 0.236ms  |  0.479ms   | Static  | Golang 1.19.6              |
| 8th.  | Kotlin     | 0.293ms  |  0.256ms   | Static  | Kotlin 1.8.10 (JRE 19.0.2) |
| 9th.  | Java       | 0.321ms  |  0.287ms   | Static  | JRE 19.0.2                 |
| 10th. | C#         | 0.322ms  |  1.923ms   | Static  | Mono 6.12.0.182            |
| 11th. | Scala      | 0.522ms  |  0.330ms   | Static  | Scala 3.2.2 (JRE 19.0.2)   |
| 12th. | Ruby       | 0.694ms  |  1.873ms   | Dynamic | TruffleRuby 22.3.1         |
| 13th. | Javascript | 0.775ms  |  1.295ms   | Dynamic | Firefox 110.0              |
| 14th. | Nim        | 1.027ms  |  1.350ms   | Static  | Nim 1.6.10                 |
| 15th. | Groovy     | 1.198ms  |  3.040ms   | Static  | Groovy 4.0.9 (JRE 19.0.2)  |
| 16th. | Swift      | 1.406ms  |  1.591ms   | Static  | Swift 5.7.2                |
| 17th. | PHP        | 1.817ms  |  1.626ms   | Dynamic | PHP 8.2.3                  |
| 18th. | Python     | 2.261ms  |  2.813ms   | Dynamic | Python 3.11.2              |
| 19th. | Ruby       | 3.430ms  |  2.586ms   | Dynamic | CRuby 3.2.1 (w/JIT)        |
| 20th. | Lua        | 4.123ms  |  2.665ms   | Dynamic | Lua 5.4.4                  |
| 21st. | Ruby       | 4.246ms  |  1.938ms   | Dynamic | JRuby 9.4.1.0 (JRE 19.0.2) |
| 22nd. | Perl       | 8.330ms  |  3.530ms   | Dynamic | Perl 5.36.0                |

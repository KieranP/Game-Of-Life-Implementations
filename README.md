# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language with a naive implementation (no language specific optimizations that can't be applied to other languages).

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

**Note:** Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

**Note:** These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM.

The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 20s), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes                          |
| :---- | :--------- | :------: | :--------: | :-----: | :----------------------------- |
| 1st.  | Crystal    | 0.122ms  |  0.959ms   | Static  | Crystal 1.3.2                  |
| 2nd.  | Go         | 0.275ms  |  0.498ms   | Static  | Golang 1.17.6                  |
| 3rd.  | Dart       | 0.312ms  |  0.618ms   | Static  | Dart 2.15.1                    |
| 4th.  | Java       | 0.329ms  |  0.265ms   | Static  | OpenJDK 17.0.1                 |
| 5th.  | Kotlin     | 0.329ms  |  0.306ms   | Static  | Kotlin 1.6.10 (OpenJDK 17.0.1) |
| 6th.  | C#         | 0.351ms  |  1.954ms   | Static  | Mono 6.12.0.122                |
| 7th.  | Javascript | 0.729ms  |  1.273ms   | Dynamic | Firefox 96.0.2                 |
| 8th.  | Scala      | 0.853ms  |  0.376ms   | Static  | Scala 2.13.8 (OpenJDK 17.0.1)  |
| 9th.  | Ruby       | 1.259ms  |  5.444ms   | Dynamic | TruffleRuby 21.3.0             |
| 10th. | Nim        | 1.339ms  |  3.573ms   | Static  | Nim 1.6.2                      |
| 11th. | Swift      | 1.435ms  |  2.187ms   | Static  | Swift 5.5.2                    |
| 12th. | Javascript | 1.618ms  |  1.332ms   | Dynamic | Chromium 97.0                  |
| 13th. | Groovy     | 1.717ms  |  3.572ms   | Static  | Groovy 3.0.9 (OpenJDK 17.0.1)  |
| 14th. | Javascript | 1.769ms  |  0.725ms   | Static  | Deno 1.17.3                    |
| 15th. | PHP        | 1.912ms  |  1.675ms   | Dynamic | PHP 8.1.2                      |
| 16th. | Javascript | 2.449ms  |  1.012ms   | Static  | Node 17.3.0                    |
| 17th. | Ruby       | 4.230ms  |  2.656ms   | Dynamic | JRuby 9.3.2.0                  |
| 18th. | Ruby       | 4.559ms  |  3.265ms   | Dynamic | CRuby 3.1.0                    |
| 19th. | Python     | 4.971ms  |  4.693ms   | Dynamic | Python 3.9.10                  |
| 20th. | Lua        | 5.008ms  |  3.236ms   | Dynamic | Lua 5.4.3                      |
| 21st. | Perl       | 13.369ms |  4.887ms   | Dynamic | Perl 5.34.0                    |

## Feature Comparison

### Static Typed Languages

**Note:** Below is a table of functionality that differs between the various static typed languages.
This list is not exhaustive, but includes some of the primary things that I came across while implementing each one.

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

**Note:** Below is a table of functionality that differs between the various dynamic typed languages.
This list is not exhaustive, but includes some of the primary things that I came across while implementing each one.

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

## Wishlist

- Rust (mostly complete - see branch)
- Elixir
- Haskell
- Erlang
- C++

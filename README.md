# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language with a naive implementation (no language specific optimizations that can't be applied to other languages).

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM.

The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 20s), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes          |
|:------|:-----------|:--------:|:----------:|:-------:|:---------------|
| 1st.  | Crystal    | 0.105ms  |  0.960ms   | Static  | Crystal 0.34.0 |
| 2nd.  | Dart       | 0.268ms  |  0.548ms   | Static  | Dart 2.8.1     |
| 3rd.  | Go         | 0.288ms  |  0.550ms   | Static  | Golang 1.14.2  |
| 4th.  | Kotlin     | 0.310ms  |  0.257ms   | Static  | Kotlin 1.3.72  |
| 5th.  | Java       | 0.320ms  |  0.258ms   | Static  | OpenJDK 14.0.1 |
| 6th.  | C#         | 0.322ms  |  2.501ms   | Static  | Mono 6.8.0.105 |
| 7th.  | Javascript | 0.602ms  |  1.358ms   | Dynamic | Firefox 76.0.1 |
| 8th.  | Scala      | 0.682ms  |  0.315ms   | Static  | Scala 2.13.2   |
| 9th.  | Nim        | 1.186ms  |  3.053ms   | Static  | Nim 1.2.0      |
| 10th. | Groovy     | 1.310ms  |  3.009ms   | Static  | Groovy 3.0.3   |
| 11th. | Swift      | 1.470ms  |  2.170ms   | Static  | Swift 5.1.3    |
| 12th. | Javascript | 1.579ms  |  0.646ms   | Static  | Deno 1.0.0     |
| 13th. | Javascript | 1.823ms  |  1.363ms   | Dynamic | Chromium 81.0  |
| 14th. | PHP        | 1.928ms  |  1.646ms   | Dynamic | PHP 7.3.11     |
| 15th. | Javascript | 2.298ms  |  0.919ms   | Static  | Node 14.2.0    |
| 16th. | Ruby       | 5.142ms  |  3.428ms   | Dynamic | Ruby 2.7.1     |
| 17th. | Python     | 5.315ms  |  5.237ms   | Dynamic | Python 3.7.7   |
| 18th. | Lua        | 5.597ms  |  3.397ms   | Dynamic | Lua 5.3.5      |

## Feature Comparison

### Static Typed Languages

*Note:* Below is a table of functionality that differs between the various static typed languages.
This list is not exhaustive, but includes some of the primary things that I came across while implementing each one.

| Feature                          | C# | Crystal | Dart | Go | Groovy | Java | Kotlin | Nim | Scala | Swift | TypeScript |
|:---------------------------------|:--:|:-------:|:----:|:--:|:------:|:----:|:------:|:---:|:-----:|:-----:|:----------:|
| Runs Without Compiling           | ✖  |    ✖    |  ✔   | ✖  |   ✔    |  ✖   |   ✖    |  ✖  |   ✖   |   ✖   |     ✖      |
| Classes/Objects (Top Level)      | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Classes/Objects (Nested)         | ✔  |    ✔    |  ✖   | ✖  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✖   |     ✔      |
| Class/Object Initializer         | ✔  |    ✔    |  ✔   | ✖  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✔   |     ✔      |
| Class/Object Methods             | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✔   |     ✔      |
| Class/Object Method Visibility   | ✔  |    ✔    |  ✔   | ▵  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✔   |     ✔      |
| Class/Object Variables           | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✖   |     ✔      |
| Class/Object Variable Visibility | ✔  |    ✔    |  ✔   | ▵  |   ✔    |  ✔   |   ✔    |  ✖  |   ✔   |   ✖   |     ✔      |
| Instance Methods                 | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Instance Method Visibility       | ✔  |    ✔    |  ✔   | ▵  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Instance Variables               | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Instance Variable Visibility     | ✔  |    ✔    |  ✔   | ▵  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Named Parameters/Arguments       | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✖   |   ✔    |  ✖  |   ✔   |   ✔   |     ✖      |
| Default Parameters/Arguments     | ✔  |    ✔    |  ✔   | ✖  |   ✔    |  ✖   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| semicolon optional               | ✖  |    ✔    |  ✖   | ✔  |   ✔    |  ✖   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| return keyword optional          | ✖  |    ✔    |  ✖   | ✖  |   ✔    |  ✖   |   ✖    |  ✔  |   ✔   |   ✖   |     ✖      |
| Looping over Array (value)       | ✔  |    ✔    |  ✔   | ✔  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Looping over Hash (key/value)    | ✔  |    ✔    |  ✔   | ✔  |   ✖    |  ✖   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Custom Exceptions                | ✔  |    ✔    |  ✔   | ✖  |   ✔    |  ✔   |   ✔    |  ✔  |   ✔   |   ✔   |     ✔      |
| Exceptions Must Be Caught        | ✖  |    ✖    |  ✖   | ✖  |   ✖    |  ✔   |   ✖    |  ✖  |   ✖   |   ✔   |     ✖      |

 ▵ visibility for package, not for object scope.


### Dynamic Typed Languages

*Note:* Below is a table of functionality that differs between the various dynamic typed languages.
This list is not exhaustive, but includes some of the primary things that I came across while implementing each one.

| Feature                          | Javascript | Lua | PHP | Python | Ruby |
|:---------------------------------|:----------:|:---:|:---:|:------:|:----:|
| Runs Without Compiling           |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Classes/Objects (Top Level)      |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Classes/Objects (Nested)         |     ✔      |  ✔  |  ✖  |   ✔    |  ✔   |
| Class/Object Initializer         |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Class/Object Methods             |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Class/Object Method Visibility   |     ✖      |  ✖  |  ✔  |   ✖    |  ✔   |
| Class/Object Variables           |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Class/Object Variable Visibility |     ✖      |  ✖  |  ✔  |   ✖    |  ✔   |
| Instance Methods                 |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Instance Method Visibility       |     ✖      |  ✖  |  ✔  |   ✖    |  ✔   |
| Instance Variables               |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Instance Variable Visibility     |     ✖      |  ✖  |  ✔  |   ✖    |  ✔   |
| Named Parameters/Arguments       |     ✖      |  ✖  |  ✖  |   ✖    |  ✔   |
| Default Parameters/Arguments     |     ✔      |  ✖  |  ✔  |   ✔    |  ✔   |
| semicolon optional               |     ✔      |  ✔  |  ✖  |   ✔    |  ✔   |
| return keyword optional          |     ✖      |  ✖  |  ✖  |   ✖    |  ✔   |
| Looping over Array (value)       |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Looping over Hash (key/value)    |     ✖      |  ✔  |  ✔  |   ✔    |  ✔   |
| Custom Exceptions                |     ✔      |  ✔  |  ✔  |   ✔    |  ✔   |
| Exceptions Must Be Caught        |     ✖      |  ✖  |  ✖  |   ✖    |  ✖   |

## Wishlist
* Rust (mostly complete - see branch)
* Elixir
* Haskell
* Erlang
* C++
* Perl

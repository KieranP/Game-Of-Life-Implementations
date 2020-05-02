# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language with a naive implementation (no language specific optimizations that can't be applied to other languages).

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM.

The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 20s), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes                            |
|:------|:-----------|:--------:|:----------:|:-------:|:---------------------------------|
| 1st.  | Crystal    | 0.252ms  |  1.784ms   | Static  | Crystal 0.31.1                   |
| 2nd.  | Dart       | 0.279ms  |  0.610ms   | Static  | Dart 2.6.0                       |
| 3rd.  | Go         | 0.332ms  |  0.590ms   | Static  | Golang 1.13.4                    |
| 4th.  | Java       | 0.333ms  |  0.311ms   | Static  | OpenJDK 13+33                    |
| 5th.  | Kotlin     | 0.337ms  |  0.313ms   | Static  | Kotlin 1.3.50 (OpenJDK 13+33)    |
| 6th.  | C#         | 0.360ms  |  2.994ms   | Static  | Mono 6.4.0.198                   |
| 7th.  | Javascript | 0.610ms  |  1.312ms   | Dynamic | SpiderMonkey 60 (Firefox 70.0.1) |
| 8th.  | Scala      | 1.024ms  |  0.444ms   | Static  | Scala 2.13.1 (OpenJDK 13+33)     |
| 9th.  | Nim        | 1.553ms  |  4.168ms   | Static  | Nim 1.0.2                        |
| 10th. | Swift      | 1.578ms  |  1.994ms   | Static  | Swift 5.0.1                      |
| 11th. | Groovy     | 1.994ms  |  3.604ms   | Static  | Groovy 2.5.8 (OpenJDK 13+33)     |
| 12th. | Javascript | 2.109ms  |  1.370ms   | Dynamic | V8 7.8.279.19                    |
| 13th. | Javascript | 2.224ms  |  1.260ms   | Static  | Typescript 3.2.2 (Node 11.5.0)   |
| 14th. | PHP        | 2.376ms  |  2.081ms   | Dynamic | PHP 7.3.11                       |
| 15th. | Ruby       | 5.301ms  |  4.704ms   | Dynamic | Ruby 2.6.5                       |
| 16th. | Python     | 6.687ms  |  6.220ms   | Dynamic | Python 3.7.5                     |
| 17th. | Lua        | 8.260ms  |  4.539ms   | Dynamic | Lua 5.3.5                        |

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

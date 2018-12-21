# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language with a naive implementation (no language specific optimizations that can't be applied to other languages).

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM.

The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 10k ticks), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes                               |
|:------|:-----------|:--------:|:----------:|:-------:|:------------------------------------|
| 1st.  | Dart       | 0.00028s |  0.00053s  | Static  | Dart 2.1.0                          |
| 2nd.  | C#         | 0.00028s |  0.00344s  | Static  | Mono 5.14.0.177                     |
| 3rd.  | Kotlin     | 0.00029s |  0.00025s  | Static  | Kotlin 1.3.11 (OpenJDK 11.0.1)      |
| 4th.  | Java       | 0.00030s |  0.00023s  | Static  | OpenJDK 11.0.1                      |
| 5th.  | Go         | 0.00030s |  0.00053s  | Static  | Golang 1.11.4                       |
| 6th.  | Crystal    | 0.00030s |  0.00183s  | Static  | Crystal 0.27.0                      |
| 7th.  | Scala      | 0.00056s |  0.00041s  | Static  | Scala 2.12.8 (OpenJDK 11.0.1)       |
| 8th.  | Javascript | 0.00092s |  0.00133s  | Dynamic | SpiderMonkey 60 (Firefox 64.0)      |
| 9th.  | Swift      | 0.00127s |  0.00211s  | Static  | Swift 4.2.1                         |
| 10th. | Groovy     | 0.00134s |  0.00290s  | Static  | Groovy 2.5.4 (OpenJDK 11.0.1)       |
| 11th. | Nim        | 0.00143s |  0.00375s  | Static  | Nim 0.19.0                          |
| 12th. | Javascript | 0.00185s |  0.00089s  | Static  | Typescript 3.2.2 (Node 11.5.0)      |
| 13th. | Javascript | 0.00196s |  0.00100s  | Dynamic | V8 7.1.302.31 (Chrome 71.0.3578.98) |
| 14th. | PHP        | 0.00232s |  0.00193s  | Dynamic | PHP 7.3.0                           |
| 15th. | Ruby       | 0.00486s |  0.00475s  | Dynamic | Ruby 2.5.3                          |
| 16th. | Python     | 0.00549s |  0.00554s  | Dynamic | Python 3.7.1                        |

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

| Feature                          | Javascript | PHP | Python | Ruby |
|:---------------------------------|:----------:|:---:|:------:|:----:|
| Runs Without Compiling           |     ✔      |  ✔  |   ✔    |  ✔   |
| Classes/Objects (Top Level)      |     ✔      |  ✔  |   ✔    |  ✔   |
| Classes/Objects (Nested)         |     ✔      |  ✖  |   ✔    |  ✔   |
| Class/Object Initializer         |     ✔      |  ✔  |   ✔    |  ✔   |
| Class/Object Methods             |     ✔      |  ✔  |   ✔    |  ✔   |
| Class/Object Method Visibility   |     ✖      |  ✔  |   ✖    |  ✔   |
| Class/Object Variables           |     ✔      |  ✔  |   ✔    |  ✔   |
| Class/Object Variable Visibility |     ✖      |  ✔  |   ✖    |  ✔   |
| Instance Methods                 |     ✔      |  ✔  |   ✔    |  ✔   |
| Instance Method Visibility       |     ✖      |  ✔  |   ✖    |  ✔   |
| Instance Variables               |     ✔      |  ✔  |   ✔    |  ✔   |
| Instance Variable Visibility     |     ✖      |  ✔  |   ✖    |  ✔   |
| Named Parameters/Arguments       |     ✖      |  ✖  |   ✖    |  ✔   |
| Default Parameters/Arguments     |     ✔      |  ✔  |   ✔    |  ✔   |
| semicolon optional               |     ✔      |  ✖  |   ✔    |  ✔   |
| return keyword optional          |     ✖      |  ✖  |   ✖    |  ✔   |
| Looping over Array (value)       |     ✔      |  ✔  |   ✔    |  ✔   |
| Looping over Hash (key/value)    |     ✖      |  ✔  |   ✔    |  ✔   |
| Custom Exceptions                |     ✔      |  ✔  |   ✔    |  ✔   |
| Exceptions Must Be Caught        |     ✖      |  ✖  |   ✖    |  ✖   |

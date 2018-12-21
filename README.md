# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language with a naive implementation (no language specific optimizations that can't be applied to other languages).

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2018), 2.6 GHz Intel Core i7, with 32 GB of 2400 MHz DDR4 RAM.

The times were calculated by playing each simulation for long enough that the average tick time becomes stable (normally around 10k ticks), and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes                               |
|:------|:-----------|:--------:|:----------:|:-------:|:------------------------------------|
| 1st.  | C#         | 0.271ms  |  3.487ms   | Static  | Mono 5.14.0.177                     |
| 2nd.  | Dart       | 0.281ms  |  0.522ms   | Static  | Dart 2.1.0                          |
| 3rd.  | Kotlin     | 0.297ms  |  0.256ms   | Static  | Kotlin 1.3.11 (OpenJDK 11.0.1)      |
| 4th.  | Go         | 0.306ms  |  0.530ms   | Static  | Golang 1.11.4                       |
| 5th.  | Java       | 0.307ms  |  0.246ms   | Static  | OpenJDK 11.0.1                      |
| 6th.  | Crystal    | 0.314ms  |  1.989ms   | Static  | Crystal 0.27.0                      |
| 7th.  | Scala      | 0.537ms  |  0.393ms   | Static  | Scala 2.12.8 (OpenJDK 11.0.1)       |
| 8th.  | Javascript | 0.963ms  |  1.321ms   | Dynamic | SpiderMonkey 60 (Firefox 64.0)      |
| 9th.  | Swift      | 1.279ms  |  2.119ms   | Static  | Swift 4.2.1                         |
| 10th. | Nim        | 1.413ms  |  3.654ms   | Static  | Nim 0.19.0                          |
| 11th. | Groovy     | 1.435ms  |  2.926ms   | Static  | Groovy 2.5.4 (OpenJDK 11.0.1)       |
| 12th. | Javascript | 1.858ms  |  0.874ms   | Static  | Typescript 3.2.2 (Node 11.5.0)      |
| 13th. | Javascript | 1.963ms  |  1.001ms   | Dynamic | V8 7.1.302.31 (Chrome 71.0.3578.98) |
| 14th. | PHP        | 2.289ms  |  1.910ms   | Dynamic | PHP 7.3.0                           |
| 15th. | Ruby       | 4.751ms  |  4.600ms   | Dynamic | Ruby 2.5.3                          |
| 16th. | Python     | 5.325ms  |  5.360ms   | Dynamic | Python 3.7.1                        |

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

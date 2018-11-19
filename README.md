# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language.

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2014), 2.5 GHz Intel Core i7, with 16 GB of 1600 MHz DDR3 RAM. The times were calculated by playing each simulation for long enough that the average tick time becomes stable, and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg |  Typed  | Notes                               |
|:------|:-----------|:--------:|:----------:|:-------:|:------------------------------------|
| 1st.  | Crystal    | 0.00030s |  0.00209s  | Static  | Crystal 0.25.1                      |
| 2nd.  | C#         | 0.00030s |  0.00455s  | Static  | Mono 5.12.0.226                     |
| 3rd.  | Go         | 0.00032s |  0.00055s  | Static  | Golang 1.11.2                       |
| 4th.  | Java       | 0.00035s |  0.00032s  | Static  | Java 1.8.0_101                      |
| 5th.  | Kotlin     | 0.00035s |  0.00034s  | Static  | Kotlin 1.2.60                       |
| 6th.  | Dart       | 0.00038s |  0.00072s  | Static  | Dart 2.0.0                          |
| 7th.  | Scala      | 0.00075s |  0.00050s  | Static  | Scala 2.12.6                        |
| 8th.  | Javascript | 0.00113s |  0.00245s  | Dynamic | SpiderMonkey 60 (Firefox 60.0.2)    |
| 9th.  | Groovy     | 0.00139s |  0.00324s  | Static  | Groovy 2.5.1                        |
| 10th. | Nim        | 0.00144s |  0.00339s  | Static  | Nim 0.18.0                          |
| 11th. | Swift      | 0.00197s |  0.00530s  | Static  | Swift 4.0.3                         |
| 12th. | Javascript | 0.00260s |  0.00134s  | Static  | Typescript 3.0.1 / Node 8.9.4       |
| 13th. | PHP        | 0.00270s |  0.00249s  | Dynamic | PHP 7.2.6                           |
| 14th. | Javascript | 0.00274s |  0.00129s  | Dynamic | V8 6.7.288.46 (Chrome 67.0.3396.87) |
| 15th. | Ruby       | 0.00595s |  0.00519s  | Dynamic | Ruby 2.5.1                          |
| 16th. | Python     | 0.00699s |  0.00770s  | Dynamic | Python 3.6.2                        |

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

# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language.

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2014), 2.5 GHz Intel Core i7, with 16 GB of 1600 MHz DDR3 RAM. The times were calculated by playing each simulation for long enough that the average tick time becomes stable, and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg | Notes                               |
|:------|:-----------|:--------:|:----------:|:------------------------------------|
| 1st.  | Dart       | 0.00027s |  0.00062s  | Dart 1.24.2                         |
| 2nd.  | Crystal    | 0.00031s |  0.00212s  | Crystal 0.25.0                      |
| 3rd.  | Java       | 0.00036s |  0.00032s  | Java 1.8.0_101                      |
| 4th.  | Kotlin     | 0.00036s |  0.00034s  | Kotlin 1.1.51                       |
| 5th.  | C#         | 0.00036s |  0.00438s  | Mono 5.0.1.1                        |
| 6th.  | Scala      | 0.00074s |  0.00125s  | Scala 2.12.3                        |
| 7th.  | Javascript | 0.00083s |  0.00133s  | SpiderMonkey 45 (Firefox 55.0.3)    |
| 8th.  | Javascript | 0.00221s |  0.00154s  | V8 6.1.534.37 (Chrome 61.0.3163.91) |
| 9th.  | Swift      | 0.00237s |  0.00543s  | Swift 4.0                           |
| 10th. | PHP        | 0.00244s |  0.00232s  | PHP 7.1.8                           |
| 11th. | Ruby       | 0.00459s |  0.00426s  | Ruby 2.4.1                          |
| 12th. | Python     | 0.00682s |  0.00709s  | Python 3.6.2                        |

## Feature Comparison

*Note:* Below is a table of functionality that differs between the various languages. This list is not exhaustive, but includes some of the primary things that I came across while implementing each one.

| Feature                       | C# | Crystal | Dart | Java | Javascript | Kotlin | PHP | Python | Ruby | Scala | Swift |
|:------------------------------|:--:|:-------:|:----:|:----:|:----------:|:------:|:---:|:------:|:----:|:-----:|:-----:|
| Runs Without Compiling        | ✖  |    ✖    |  ✔   |  ✖   |     ✔      |   ✖    |  ✔  |   ✔    |  ✔   |   ✖   |   ✖   |
| Static Typed                  | ✔  |    ✔    |  ✔   |  ✔   |     ✖      |   ✔    |  ✖  |   ✖    |  ✖   |   ✔   |   ✔   |
| Classes (Top Level)           | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Classes (Nested)              | ✔  |    ✔    |  ✖   |  ✔   |     ✔      |   ✔    |  ✖  |   ✔    |  ✔   |   ✔   |   ✖   |
| Class Initializer             | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Class Methods                 | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Class Method Visibility       | ✔  |    ✔    |  ✔   |  ✔   |     ✖      |   ✔    |  ✔  |   ✖    |  ✔   |   ✔   |   ✔   |
| Class Variables               | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✖   |
| Class Variable Visibility     | ✔  |    ✔    |  ✔   |  ✔   |     ✖      |   ✔    |  ✔  |   ✖    |  ✔   |   ✔   |   ✖   |
| Instance Methods              | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Instance Method Visibility    | ✔  |    ✔    |  ✔   |  ✔   |     ✖      |   ✔    |  ✔  |   ✖    |  ✔   |   ✔   |   ✔   |
| Instance Variables            | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Instance Variable Visibility  | ✔  |    ✔    |  ✔   |  ✔   |     ✖      |   ✔    |  ✔  |   ✖    |  ✔   |   ✔   |   ✔   |
| Named Parameters/Arguments    | ✔  |    ✔    |  ✔   |  ✖   |     ✖      |   ✔    |  ✖  |   ✖    |  ✔   |   ✔   |   ✔   |
| Default Parameters/Arguments  | ✔  |    ✔    |  ✔   |  ✖   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| semicolon optional            | ✖  |    ✔    |  ✖   |  ✖   |     ✔      |   ✔    |  ✖  |   ✔    |  ✔   |   ✔   |   ✔   |
| return keyword optional       | ✖  |    ✔    |  ✖   |  ✖   |     ✖      |   ✖    |  ✖  |   ✖    |  ✔   |   ✔   |   ✖   |
| Looping over Array (value)    | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Looping over Hash (key/value) | ✔  |    ✔    |  ✔   |  ✖   |     ✖      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Custom Exceptions             | ✔  |    ✔    |  ✔   |  ✔   |     ✔      |   ✔    |  ✔  |   ✔    |  ✔   |   ✔   |   ✔   |
| Exceptions Must Be Caught     | ✖  |    ✖    |  ✖   |  ✔   |     ✖      |   ✖    |  ✖  |   ✖    |  ✖   |   ✖   |   ✔   |

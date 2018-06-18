# Multi-language implementations of Conway's Game of Life

The goal of this project is to create near identical implementations of "[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway's_Game_of_Life)" (GOL) in multiple programming languages. I'm doing this in an effort to learn new programming languages, and get a rough idea of the syntax differences and runtime speed of each language.

In order to give a fair comparison, all implementations are coded as similarly as possible using features available in the core language (no frameworks where possible). Each implementation demonstrates basic control flow (if, for, foreach, while, etc), as well as core concepts of each language (such as variable assignment, method definition, arrays/lists, hashes/dictionaries, etc). It also uses standard OOP features (such as class definitions/variables/methods, instance variables/methods, class/variable/method visibility).

*Note:* Because I've kept all implementations as similar as possible, the runtime of some implementations may not run as fast as they could if I had used native patterns/optimized functions available only in that language. I want to avoid language specific optimizations where possible. However, there may be general optimizations that can be applied to all implementations which could speed things up. If anyone notices any, please open a Github issue detailing the possible improvement.

## Speed Results (by tick time)

*Note:* These speed results are taken on a Macbook Pro 15" Retina (Mid 2014), 2.5 GHz Intel Core i7, with 16 GB of 1600 MHz DDR3 RAM. The times were calculated by playing each simulation for long enough that the average tick time becomes stable, and then grabbing the averages.

| Place | Language   | Tick Avg | Render Avg | Notes                               |
|:------|:-----------|:--------:|:----------:|:------------------------------------|
| 1st.  | Dart       | 0.00027s |  0.00062s  | Dart 1.24.3                         |
| 2nd.  | C#         | 0.00029s |  0.00448s  | Mono 5.12.0.226                     |
| 3rd.  | Crystal    | 0.00030s |  0.00209s  | Crystal 0.25.0                      |
| 4th.  | Java       | 0.00036s |  0.00032s  | Java 1.8.0_101                      |
| 5th.  | Kotlin     | 0.00036s |  0.00034s  | Kotlin 1.2.50                       |
| 6th.  | Scala      | 0.00075s |  0.00050s  | Scala 2.12.6                        |
| 7th.  | Javascript | 0.00113s |  0.00245s  | SpiderMonkey 60 (Firefox 60.0.2)    |
| 8th.  | Swift      | 0.00238s |  0.00553s  | Swift 4.0.3                         |
| 9th.  | PHP        | 0.00270s |  0.00249s  | PHP 7.2.6                           |
| 10th. | Javascript | 0.00274s |  0.00129s  | V8 6.7.288.46 (Chrome 67.0.3396.87) |
| 11th. | Ruby       | 0.00595s |  0.00519s  | Ruby 2.5.1                          |
| 12th. | Python     | 0.00699s |  0.00770s  | Python 3.6.2                        |

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

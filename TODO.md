# TODO

Open findings from the September 2026 scans, most severe first.

## Latent bugs

1. **Fixed-size hashmaps**: c `world.c:43` and fortran `hashmap.f90:14` have
   16384 slots and silently drop inserts once full (a 200x100 board loses and
   leaks 3616 cells).
2. **assemblyscript** `_f` (`assembly/index.ts:61`): `Math.round(value * 1000)`
   rounds 0.2345 to "0.235" where `%.3f` gives "0.234". The exact fix (~25
   lines of bit arithmetic) was rejected as unmaintainable.

## Inconsistencies

3. **Play type and run**: Scala has no Play, Pony uses `Main` and Perl `main`.
   C, Erlang, Fortran and Gleam have no `run`. Obj-C and Swift entry files are
   `main.m`/`main.swift`.
4. **Visibility**:
   - Should be private but are public: python, pony, odin, dlang, c++,
     ballerina, assemblyscript, clojure, dart, elixir, ruby, perl (`my method`),
     scala (top-level `private`), ocaml (`World.directions`), zig (`Errors`),
     fortran (World components), crystal (Play constants), rust
     (`LocationOccupied`).
   - Erlang exports `cells/1` only for `cell:alive_neighbours`; Haskell and
     Gleam pass the map in.
   - F#: private helpers fail at runtime, but `exception private` works.
   - Obj-C `x`/`y` are `readwrite`.
   - V's `to_char`, `alive_neighbours`, `run` and Inko's `run` aren't `pub`.
5. **Types**:
   - Kotlin uses `Int` though `UInt` works.
   - F# `AliveNeighbours` and Crystal `alive_neighbours` return signed ints; F#
     `MakeKey` is generic.
   - D uses 32-bit float timings and `int` coordinates. Haskell's `makeKey` and
     `directions` use `Int`, so `cellAt` converts on every call.
   - Julia uses `UInt64` and Obj-C `NSUInteger` instead of UInt32.
   - `WORLD_WIDTH`/`WORLD_HEIGHT` are `int` or untyped in c, c++, ballerina, v,
     dlang, nim, zig, java, groovy, ocaml, fortran, scala and kotlin.
   - DIRECTIONS are 64-bit in Odin and `i8` in Zig.
   - Odin, Scala and Fortran draw 32-bit random floats. PHP 8.3+ has
     `Randomizer::nextFloat()`.
   - `lowest_tick`/`lowest_render` start at max double, not infinity, in c#,
     java, kotlin, scala, groovy, swift, zig, julia, odin and fortran.
   - Groovy's `0.0` totals are BigDecimal; `0.0d` is a double.
   - TypeScript falls back to `alive` instead of false. Zig `.?`, Kotlin `!!`,
     C++ `.value()`, D `.get` and Java unboxing throw on null instead.
6. **Recorded rules**: AssemblyScript `_f` and C `min_double` use ternaries.
   Elixir `world.ex:143` inlines `make_key`.
7. **Labels**: Rust unsafe says "slowest", Crystal "This following", V's end in
   a colon. "About the same speed" appears 14 times across c++, zig, dlang,
   rust, crystal, fortran, julia, odin and v but never in Ruby. Inko's "slower"
   variant may be faster.
8. **Commented variants**:
   - Scala render variants have an unused `var (x, y)`, a `var rendering`, and
     `!= None` instead of `isDefined`.
   - Stray semicolons in Kotlin `world.kt:65,75` and Swift `cell.swift:25`.
   - C#'s List variant uses `List<String>`, `String.Join` and a needless
     `.ToArray()`.
   - C#, Java and Kotlin lambda alive_neighbours variants build a list to count
     it.
   - Crystal loops with `.times.each` and `size-1` with `upto`; F#
     (`cell.fs:27`) counts to `Length-1`.
   - TypeScript `world.ts:66` and `cell.ts:28` use `let` instead of `const`.
9. **Missing variants**: Rust make_key string concatenation, Inko
   alive_neighbours `for` counter, Swift and Python render builders.
10. **Structure**:
    - AssemblyScript `makeKey` is `private static`, its exception message uses
      `key`, `addCell` builds the key before the `existing` check, and lows use
      an `if` instead of `Math.min`.
    - Ballerina `addCell` creates the cell before the key, and timing converts
      seconds to ns and back.
    - Fortran converts to ms inline in `play.f90`; `f` only formats.
    - SQL increments `tickCount` before the tick.
    - Julia's tick local is `alive_neighbours_count`.
    - World fields are ordered width, height, tick, cells in odin, c, elixir,
      erlang and gleam.
    - Scala `Directions` and F# `directions` are per-instance.
    - F#'s `World(...)` returns an empty world that `Play.Run` populates.
    - Elixir and Lisp `neighbours` default to nil, so Lisp's
      `alive-neighbours` fails on a fresh cell. Elixir formats with `#~.B`,
      Erlang `#~B`.
    - Gleam `add_cell` returns no bool. Elixir/Erlang `add_cell` and Odin
      `new_cell` have no `alive = false` default.
    - Python and PHP cell constructors also take `next_state` and `neighbours`.
    - Obj-C raises a plain `NSException`, not a LocationOccupied subclass.
    - Zig's `error: LocationOccupied` has no `(x-y)`.
    - C mallocs an array of all cells inside the timed tick, unchecked, though
      `hashmap_iterator` exists.
    - R's render (`world.r:78`) increments `idx` outside the guard.
    - Perl `world.pm:39,41` stores `1`/`0` in `next_state`, not `true`/`false`.
    - Kotlin `world.kt:87` appends `"\n"`, not `'\n'`.
    - Groovy's `World` alone is explicitly `public`.
    - Obj-C's string builder isn't preallocated.
11. **Leftovers**: D `play.d:1` imports `stdout`. C# `play.cs:2` keeps
    `// using System.Linq;`. C `hashmap_iterator_reset` is unused and nothing
    reads the iterator's `key`. Fortran `world.f90:81` declares an unused `i`.
    Inko wraps one of four `stdout.print` calls in `let _ =`. Dart uses
    `while(true)` and orders package imports before `dart:`.
12. **Docs and comments**:
    - SQL README says one `UPDATE` per tick (there are three) and
      "pointers/references" instead of "pointers/shared references".
    - SQLite `init.sql` mentions autoanalyze, which SQLite lacks.
    - SQL benchmark prints the CLI versions, not the drivers'.
    - SQL README's brew `postgresql`/`sqlite3` are keg-only, and it doesn't say
      to start the server.
    - Pony's continuous-loop note is non-standard and wrong: `while true`
      exists, but actor GC only runs between behaviours. Clojure's is wrong too:
      `while` exists, but locals are immutable.
    - AssemblyScript Notes don't say `throw` only aborts. TypeScript lacks the
      printf-style note Dart has.
    - Version headers: kotlin prints "info: kotlinc-jvm", odin the binary's
      path, r "Rscript" twice.
    - C/C++ READMEs say `brew install gcc`, but `gcc` is Apple clang (brew's is
      `gcc-16`).
    - Java, Kotlin, Scala and Groovy READMEs install keg-only `java`. Clojure's
      only says `brew install clojure`.
    - Crystal README uses the old formula `crystal-lang`.
    - AssemblyScript README lacks a node install step; `package-lock.json` pins
      0.28.14 but `node_modules` has 0.28.19.
    - Elixir's `rm *.beam` always fails, and benchmark.sh compiles through
      `benchmark`, so `COMPILEONLY=true` checks nothing.
    - OCaml's `-O3` does nothing without flambda.
    - R note says x/y are `numeric`; they are `integer`.
    - Rust README puts both binaries in one code block with inconsistent
      comments instead of `###` headings.
    - Root README omits brew coreutils (`timeout`) and `rustc` (memory mode).
    - MODERNIZE.md claims Kotlin lacks `String.format("%.3f")`, which
      `play.kt:47` uses.
    - IMPLEMENTATION.md has "Lamdba", and its `[x, "-", y].join` differs from
      Ruby's `[x, y].join('-')`.
    - Nim comment typos: "dont", "To to".

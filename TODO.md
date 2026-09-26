# TODO

Findings from the 2026-09-24 and 2026-09-26 scans, most severe first.

## High: wrong benchmark numbers

- [ ] 1. **ocaml** `play.ml:46`: stdout is block-buffered (64 KB) even on a pty,
      and in MINIMAL mode only `print_endline` would flush. The harness SIGKILLs
      the process, so the captured stats line is up to about 900 ticks stale,
      and a line cut at "A: x.xxx)" still matches the result grep. A 2s run
      captured exactly 912 lines, one buffer's worth.
- [ ] 2. **ruby** `benchmark.sh:17-19`: the local Ruby 4.0.6 was built without
      ZJIT, so the "w/ ZJIT" run benchmarks the interpreter. The warning goes to
      stderr, which the harness drops, and every header prints plain
      `ruby --version`. `ruby --yjit --version` / `ruby --zjit --version` would
      show the JIT tag.
- [ ] 3. **sql** `benchmark.sh:15`: memory mode samples only the Go client's
      process tree, so the PostgreSQL "Max RSS" (17 MB) leaves out the backend
      that holds the world (36 MB). SQLite runs in-process and is correct.
- [ ] 4. **lisp** `play.lisp:27,34`: on Linux, SBCL's `get-internal-real-time`
      reads `CLOCK_MONOTONIC_COARSE` (1-4 ms ticks) while a tick takes about
      0.35 ms. macOS uses `CLOCK_MONOTONIC` and is correct. Unproven: read from
      SBCL's `unix.lisp`, not run on Linux.

## Medium: wrong output or behaviour

- [ ] 5. **assemblyscript** `world.ts:3-7,131-134`: an occupied cell aborts with
      `abort: 0-0 in assembly/world.ts(134:7)`. The AS compiler takes the abort
      message from the first constructor argument, so the full
      `LocationOccupied(x-y)` string has to be built at the throw site.
- [ ] 6. **gleam** `world.gleam:93`: an occupied cell crashes on
      `let assert Ok(world)` with "Pattern match failed ...
      Error(LocationOccupied(1, 2))" instead of `LocationOccupied(1-2)`.
- [ ] 7. **gleam** `play.gleam:71-79`: `f` uses `float.to_string`, which prints
      round values of 1000 ms or more as `1.0e3` or `1.2e4`.
- [ ] 8. **fortran** `play.f90:20,31-32`: `MINIMAL="1 "` turns on minimal mode,
      because Fortran pads the comparison with blanks.

## Low: latent bugs

- [ ] 9. **Zero-size world**: f# `world.fs:67,88` and haskell
      `World.hs:76,79,109,111` count to `0u - 1u` and hang; elixir
      `world.ex:54,56,106,108` walks `0..-1` as 0, -1 and creates cells at x=-1.
      Ruby builds nothing.
- [ ] 10. **c** `world.c:43`: the hashmap has 16384 fixed slots, and `add_cell`
      ignores `hashmap_put` returning false. A 200x100 board drops cells and
      leaks them.
- [ ] 11. **sql** `postgres/init.sql:1-2`: drops `cells` before `neighbours`,
      whose foreign keys reference it, so re-running on an existing database
      errors. play.go recreates the database first, so it never triggers.
- [ ] 12. **perl** `play.pl:4`, `world.pm:4` and **lua** `play.lua:1`,
      `world.lua:1` resolve modules against the current directory, so
      `perl perl/play.pl` from the repo root fails. Ruby, Python and PHP work.
- [ ] 13. **fortran** `world.f90:149-150`: LocationOccupied goes to stdout, then
      `stop 1` prints "STOP 1" to stderr. `error stop` with the message would
      match Ruby.
- [ ] 14. **erlang** `play.erl:23,28`: `timer:tc/3` floors to whole
      microseconds. Elixir and Gleam time in nanoseconds, and
      `timer:tc(..., nanosecond)` exists.
- [ ] 15. **typescript** `play.ts:3-6,23`: the undocumented Boa shim falls back
      to `Date.now()` (whole ms, not monotonic) and forces minimal mode.
- [ ] 16. **go** `world.go:63-87,106-119`: swapping in the string-concat render
      or the `fmt.Sprintf` make_key leaves `strings` or `strconv` unused, which
      Go rejects. Nothing marks the import to comment out.

## Low: inconsistencies

- [ ] 17. **Play type and run**: Scala removed Play in 43e014b. Pony has
      everything in `Main`, and Perl in `main`. C, Erlang, Fortran and Gleam
      have no `run`. Obj-C's entry file is `main.m`, not `Play.m`.
- [ ] 18. **Visibility**:
  - Helpers or constants that should be private are public in python, pony,
    odin, dlang, c++, ballerina, assemblyscript, clojure, dart, elixir, ruby,
    perl (5.42 `my method`), scala (top-level `private`), ocaml
    (`World.directions`), zig (`Errors`) and fortran (World components).
  - In F#, making the helpers private fails at runtime, but
    `exception private LocationOccupied` works.
  - Obj-C `x`/`y` are `readwrite`.
  - V's `to_char`, `alive_neighbours` and `run` are not `pub`.
- [ ] 19. **Types**:
  - Kotlin uses `Int` although `UInt` works.
  - F#'s `AliveNeighbours` returns `int`, and `MakeKey` compiles as generic.
  - D uses 32-bit floats for timings, and `int` for `makeKey`/`cellAt`/
    `addCell` parameters and `aliveNeighbours`.
  - Julia uses `UInt64` and Obj-C `NSUInteger` where UInt32 exists.
  - C++ `WORLD_WIDTH`/`WORLD_HEIGHT` are `int`, Ballerina's are `const int` and
    V's are untyped.
  - Odin (`rand.float32`) and Scala (`nextFloat`) draw 32-bit floats. PHP 8.3+
    has `Randomizer::nextFloat()` instead of `rand(0, 99)`.
  - TypeScript falls back to `alive` instead of false. Zig uses `.?`, Kotlin
    `!!` and Java unboxes `Boolean`, all of which throw on null where they could
    fall back to false.
- [ ] 20. **Recorded rules**: AssemblyScript's `_f`, C's `min_double` and
      TypeScript's `minimal` (`play.ts:20-23`, nested) use ternaries. Elixir
      `world.ex:143` inlines `make_key`.
- [ ] 21. **Labels**: Rust unsafe says "slowest" and Crystal says "This
      following". V's labels end in a colon. "The following is about the same
      speed" appears 14 times across c++, zig, dlang, rust, crystal, fortran,
      julia, odin and v, and Ruby has no such label. Inko's "slower" variant
      measured faster (unproven, the timings came from parallel runs).
- [ ] 22. **Commented variants**:
  - Scala's render variants keep an unused `var (x, y)`, one uses `var` for
    `rendering`, and both check `!= None` where the active one uses `isDefined`.
  - Kotlin (`world.kt:65,75`) and Swift (`cell.swift:25`) variants have stray
    semicolons.
  - C#'s List variant uses `List<String>`, `String.Join` and a needless
    `.ToArray()`.
  - Crystal's variants loop with `.times.each`, and its index loop uses `size-1`
    with `upto`.
  - R's preallocated render (`world.r:78`) increments `idx` outside the guard.
- [ ] 23. **Structure**:
  - AssemblyScript `makeKey` is `private static`, its exception takes `key`
    rather than `(x, y)`, `addCell` builds the key before the `existing` check,
    and it tracks lows with a braceless `if` instead of `Math.min`.
  - Ballerina `addCell` creates the cell before the key.
  - SQL increments `tickCount` before the tick.
  - Julia's tick local is `alive_neighbours_count`.
  - Odin's World fields are ordered width, height, tick, cells.
  - Scala's `Directions` is a per-instance `val`.
  - Elixir `Cell.neighbours` defaults to nil, not `[]`, and its format uses
    `#~.B` where Erlang uses `#~B`.
  - Groovy's `World` alone has an explicit `public`.
- [ ] 24. **Leftovers**:
  - D `play.d:1` imports `stdout`, unused since ad4c960.
  - C# `play.cs:2` keeps `// using System.Linq;` with no LINQ left.
  - Fortran `world.f90:81` declares an unused `i`.
  - Inko wraps only one of four `stdout.print` calls in `let _ =`.
  - Dart has `while(true)` and places package imports before `dart:` ones.
- [ ] 25. **Docs and comments**:
  - The SQL README says one `UPDATE` per tick, but there are three.
  - SQLite's `init.sql` mentions autoanalyze, which SQLite doesn't have.
  - SQL's benchmark prints the CLI's SQLite version and the psql client's
    version, not the ones the runner uses.
  - The SQL README's brew `postgresql` and `sqlite3` are keg-only, and it
    doesn't say to start the server.
  - The Pony Notes don't use the standard wording, and the stated reason is
    wrong: Pony has `while true`, but actor GC only runs between behaviours (a
    `while` loop reached 5.5 GB in 8s).
  - `kotlin/benchmark.sh` prints "info: kotlinc-jvm" and `odin/benchmark.sh` the
    binary's full path as their version headers.
  - The C and C++ READMEs say `brew install gcc`, but `gcc`/`g++` are Apple
    clang and brew's GCC installs as `gcc-16`.
  - The Java, Kotlin, Scala and Groovy READMEs install keg-only `java`, which
    isn't on PATH (unproven on a clean machine). Clojure's says only
    `brew install clojure`.
  - The AssemblyScript README has no step to install node.
  - Elixir's Run command `rm *.beam` fails when no .beam files exist, which is
    always.
  - OCaml's `-O3` does nothing without flambda, which the local ocamlopt lacks.
  - The R note says x/y fall back to `numeric`, but they are `integer`.
  - The Rust README puts both binaries in one code block with inline comments
    instead of `###` headings.
  - IMPLEMENTATION.md has the typo "Lamdba", and its Array & Join form
    `[x, "-", y].join` differs from Ruby's `[x, y].join('-')`.
  - `helpers.sh` `SKIP=N` counts `node_modules/`.
  - The Nim comment has the typos "dont" and "To to".
  - Obj-C's string builder isn't preallocated.

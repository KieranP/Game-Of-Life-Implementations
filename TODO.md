# TODO

Findings from the 2026-09-24, 2026-09-26 and 2026-09-30 scans, most severe
first.

## Medium: benchmark accuracy

- [ ] 1. **sql** `db.go:88`, `sqlite/tick.sql:4-29`: mattn's `Exec` runs the
      three UPDATEs as three autocommit transactions, so every SQLite tick pays
      three journal commits. lib/pq runs the same file as one implicit
      transaction. Wrapping tick.sql in `BEGIN;`/`COMMIT;` took the SQLite
      average from 2.35 to 1.53 ms, and the gap held over two interleaved runs.

## Low: latent bugs

- [ ] 2. **Zero-size world**: f# `world.fs:67,88`, haskell
      `World.hs:76,79,109,111` and julia `world.jl:85-86,131-132` count to
      `0 - 1` unsigned and hang. Elixir `world.ex:54,56,106,108` and r
      `world.r:72-73,103-104` walk `0..-1` as 0, -1 and create cells at -1. Ruby
      builds nothing.
- [ ] 3. **Fixed-size hashmaps**: c `world.c:43` and fortran
      `hashmap.f90:14,83-101` have 16384 fixed slots, and a full table drops the
      insert without reporting it. A 200x100 board loses 3616 cells, and they
      leak.
- [ ] 4. **c** `lib/utils.c:18`: `int_to_str` takes `int`, but `make_key` passes
      `uint32_t`, so coordinates above INT_MAX give negative keys and INT_MIN
      overflows on `num = -num`. The commented `snprintf("%u-%u")` variant is
      correct.
- [ ] 5. **swift** `main.swift:49`: the stats line formats the `UInt32` tick
      with `%d`, so it prints negative from tick 2^31. `%u` is correct.
- [ ] 6. **assemblyscript** `assembly/index.ts:61-65`: `_f` rounds with
      `Math.round(value * 1000) / 1000`, which rounds values just under a .0005
      tie up. 0.2345 prints "0.235", where `%.3f` gives "0.234".
- [ ] 7. **pony** `world.pony:99`: `populate_cells` discards the
      `(Bool | LocationOccupied)` from `_add_cell`, so an occupied location is
      skipped silently. Every other error-value emulation stops the program.
- [ ] 8. **sql** `postgres/init.sql:1-2` and `sqlite/init.sql:1-2`: both drop
      `cells` before `neighbours`, whose foreign keys reference it. Re-running
      on postgres errors, and SQLite only works because foreign keys are off.
      play.go recreates the database first, so it never triggers.
- [ ] 9. **Running from the repo root** fails for perl `play.pl:4`,
      `world.pm:4`, lua `play.lua:1`, `world.lua:1`, r `play.r:1`, `world.r:1`,
      lisp (`Couldn't load "world.lisp"`), groovy
      (`unable to resolve class World`) and clojure
      (`Could not locate world__init.class`). Ruby, Python, PHP and Julia work.
- [ ] 10. **perl** `cell.pm:1`, `world.pm:1`, `play.pl:1`: the files declare
      `use v5.40`, but `cell.pm:7-8` uses the field `:writer` attribute, which
      arrived in 5.42. Unproven: no 5.40 perl was available to run.
- [ ] 11. **Crashed runs look like results**: `sample.js:50-52,84,113` exits 0
      and prints "Max RSS" when the child crashes, and `sample.js:45` has no
      `'error'` handler, so a missing command dies with an ENOENT stack trace.
- [ ] 12. **fortran** `world.f90:149-150`: LocationOccupied goes to stdout, then
      `stop 1` prints "STOP 1" to stderr. `error stop` with the message would
      match Ruby.
- [ ] 13. **erlang** `play.erl:23,28`: `timer:tc/3` floors to whole
      microseconds. Elixir and Gleam time in nanoseconds, and
      `timer:tc(..., nanosecond)` exists.
- [ ] 14. **typescript** `play.ts:3-6,23`: the undocumented Boa shim falls back
      to `Date.now()` (whole ms, not monotonic) and forces minimal mode.
- [ ] 15. **Imports left unused by a swapped variant**: go
      `world.go:63-87,106-119` (`strings`/`strconv`, a compile error).
      gleam `world.gleam:7`, `cell.gleam:2` and v `world.v:77-87` (`strings`)
      only warn, but the benchmark echoes Gleam's warnings as `!! stderr:`.
      Haskell `Cell.hs:3`'s commented `import Data.List (foldl')` is redundant
      on GHC 9.14, where `foldl'` is in the Prelude. Nothing marks any of these
      imports.

## Low: inconsistencies

- [ ] 16. **Play type and run**: Scala removed Play in 43e014b. Pony has
      everything in `Main`, and Perl in `main`. C, Erlang, Fortran and Gleam
      have no `run`. Obj-C's entry file is `main.m` and Swift's is `main.swift`,
      not `Play.m`/`play.swift`.
- [ ] 17. **Visibility**:
  - Helpers or constants that should be private are public in python, pony,
    odin, dlang, c++, ballerina, assemblyscript, clojure, dart, elixir, ruby,
    perl (5.42 `my method`), scala (top-level `private`), ocaml
    (`World.directions`), zig (`Errors`), fortran (World components), crystal
    (Play constants) and rust (`LocationOccupied`).
  - Erlang `world.erl:4,90-91` exports `cells/1` only for
    `cell:alive_neighbours`. Haskell and Gleam pass the map in instead.
  - In F#, making the helpers private fails at runtime, but
    `exception private LocationOccupied` works.
  - Obj-C `x`/`y` are `readwrite`.
  - V's `to_char`, `alive_neighbours` and `run`, and Inko's `run`, are not
    `pub`.
- [ ] 18. **Types**:
  - Kotlin uses `Int` although `UInt` works.
  - F#'s `AliveNeighbours` and Crystal's `alive_neighbours` return a signed int,
    and F#'s `MakeKey` compiles as generic.
  - D uses 32-bit floats for timings, and `int` for `makeKey`/`cellAt`/
    `addCell` parameters and `aliveNeighbours`. Haskell's `makeKey` takes `Int`
    and its `directions` are `(Int, Int)`, so `cellAt` converts on every call.
  - Julia uses `UInt64` and Obj-C `NSUInteger` where UInt32 exists.
  - `WORLD_WIDTH`/`WORLD_HEIGHT` are `int` or untyped in c (`#define`), c++,
    ballerina, v, dlang, nim, zig, java, groovy, ocaml, fortran, scala and
    kotlin.
  - DIRECTIONS are 64-bit `int` in Odin and `i8` in Zig, not Int32.
  - Odin (`rand.float32`), Scala (`nextFloat`) and Fortran (`real :: random`)
    draw 32-bit floats. PHP 8.3+ has `Randomizer::nextFloat()` instead of
    `rand(0, 99)`.
  - `lowest_tick`/`lowest_render` start at the largest finite double in c#,
    java, kotlin, scala, groovy, swift, zig, julia, odin and fortran. Ruby and
    the rest use infinity.
  - Groovy `Play.groovy:23,25`: `0.0` is a BigDecimal literal, so the totals and
    averages use BigDecimal arithmetic. `0.0d` gives doubles.
  - TypeScript falls back to `alive` instead of false. Zig uses `.?`, Kotlin
    `!!`, C++ `.value()`, D `.get` (asserts outside `--release`) and Java
    unboxes `Boolean`, all of which throw on null where they could fall back to
    false.
- [ ] 19. **Recorded rules**: AssemblyScript's `_f`, C's `min_double` and
      TypeScript's `minimal` (`play.ts:20-23`, nested) use ternaries. Elixir
      `world.ex:143` inlines `make_key`.
- [ ] 20. **Labels**: Rust unsafe says "slowest" and Crystal says "This
      following". V's labels end in a colon. "The following is about the same
      speed" appears 14 times across c++, zig, dlang, rust, crystal, fortran,
      julia, odin and v, and Ruby has no such label. Inko's "slower" variant
      measured faster (unproven, the timings came from parallel runs).
- [ ] 21. **Commented variants**:
  - Scala's render variants keep an unused `var (x, y)`, one uses `var` for
    `rendering`, and both check `!= None` where the active one uses `isDefined`.
  - Kotlin (`world.kt:65,75`) and Swift (`cell.swift:25`) variants have stray
    semicolons.
  - C#'s List variant uses `List<String>`, `String.Join` and a needless
    `.ToArray()`.
  - The lambda alive_neighbours variants in c# `cell.cs:17-19`, java
    `Cell.java:26-29` and kotlin `cell.kt:15` build a list and take its size,
    where Ruby's `count(&:alive)` counts in place.
  - Crystal's variants loop with `.times.each`, and its index loop uses `size-1`
    with `upto`. F#'s (`cell.fs:27-28`) sets `count` to `Length-1`.
  - TypeScript `world.ts:66` and `cell.ts:28` declare with `let` where the
    active code and AssemblyScript use `const`.
- [ ] 22. **Missing variants**: Rust's make_key has no string concatenation,
      Inko's alive_neighbours no `for` counter loop, and Swift's and Python's
      render no builder (`reserveCapacity`, `io.StringIO`).
- [ ] 23. **Structure**:
  - AssemblyScript `makeKey` is `private static`, its exception message is built
    from `key` rather than `(x, y)`, `addCell` builds the key before the
    `existing` check, and it tracks lows with a braceless `if` instead of
    `Math.min`.
  - Ballerina `addCell` creates the cell before the key. Its loop converts
    `monotonicNow()` seconds to ns and `_f` converts back to ms.
  - Fortran `play.f90:48,56,81-88` converts to ms inline, and `f` only formats.
  - SQL increments `tickCount` before the tick.
  - Julia's tick local is `alive_neighbours_count`.
  - World fields are ordered width, height, tick, cells in odin, c
    `world.h:7-12`, elixir `world.ex:2-7`, erlang `world.erl:7-12` and gleam
    `world.gleam:12`.
  - Scala's `Directions` and F#'s `directions` (`world.fs:15-19`) are
    per-instance.
  - F#'s `World(...)` returns an empty world, and `Play.Run` calls
    `PopulateCells`/`PrepopulateNeighbours` itself.
  - Elixir `Cell.neighbours` and Lisp `cell.lisp:15-17` default to nil, not
    `[]`, so Lisp's `alive-neighbours` raises a type error on a fresh cell.
    Elixir's format uses `#~.B` where Erlang uses `#~B`.
  - Gleam `world.gleam:94` `add_cell` returns only the World, not a bool. Elixir
    `world.ex:117` and Erlang `world.erl:131` `add_cell`, and Odin
    `cell.odin:13` `new_cell`, have no `alive = false` default.
  - Python `cell.py:3-9` and PHP `cell.php:6-12` constructors also take
    `next_state` and `neighbours`.
  - Obj-C `World.m:136` raises a plain `NSException` named LocationOccupied, not
    a subclass.
  - Zig `world.zig:16-18,142` prints `error: LocationOccupied` with no `(x-y)`.
    Pony and Ballerina keep the coordinates.
  - C `world.c:105,127` mallocs an array of every cell inside the timed tick and
    never checks for NULL, although `hashmap_iterator` exists.
  - R's active render (`world.r:78`) increments `idx` outside the guard.
  - Perl `world.pm:39,41` stores `1`/`0` in `next_state` where the rest of the
    impl uses `true`/`false`.
  - Kotlin `world.kt:87` appends `"\n"` where C#, F# and Java append `'\n'`.
  - Groovy's `World` alone has an explicit `public`.
- [ ] 24. **Leftovers**:
  - D `play.d:1` imports `stdout`, unused since ad4c960.
  - C# `play.cs:2` keeps `// using System.Linq;` with no LINQ left.
  - C `lib/hashmap.c:170` `hashmap_iterator_reset` has no callers, and nothing
    reads the iterator's `key`.
  - Fortran `world.f90:81` declares an unused `i`.
  - Inko wraps only one of four `stdout.print` calls in `let _ =`.
  - Dart has `while(true)` and places package imports before `dart:` ones.
- [ ] 25. **Docs and comments**:
  - The SQL README says one `UPDATE` per tick, but there are three. Its Notes
    say "pointers/references", not the standard "pointers/shared references".
  - SQLite's `init.sql` mentions autoanalyze, which SQLite doesn't have.
  - SQL's benchmark prints the CLI's SQLite version and the psql client's
    version, not the ones the runner uses.
  - The SQL README's brew `postgresql` and `sqlite3` are keg-only, and it
    doesn't say to start the server.
  - The Pony Notes don't use the standard wording, and the stated reason is
    wrong: Pony has `while true`, but actor GC only runs between behaviours (a
    `while` loop reached 5.5 GB in 8s). Clojure's "No support for continuous
    loops" is wrong too: `while` exists, but locals are immutable.
  - The AssemblyScript Notes don't say `throw` only aborts (no native
    exceptions). TypeScript has no printf-style note although Dart has one for
    the same `toFixed` situation.
  - `kotlin/benchmark.sh` prints "info: kotlinc-jvm", `odin/benchmark.sh` the
    binary's full path and `r/benchmark.sh` "Rscript" twice as their version
    headers.
  - The C and C++ READMEs say `brew install gcc`, but `gcc`/`g++` are Apple
    clang and brew's GCC installs as `gcc-16`.
  - The Java, Kotlin, Scala and Groovy READMEs install keg-only `java`, which
    isn't on PATH (unproven on a clean machine). Clojure's says only
    `brew install clojure`.
  - The Crystal README uses the old formula name `crystal-lang`.
  - The AssemblyScript README has no step to install node, and
    `package-lock.json` pins assemblyscript 0.28.14 while the local
    `node_modules` has 0.28.19.
  - Elixir's Run command `rm *.beam` fails when no .beam files exist, which is
    always. Its benchmark.sh runs `elixirc` through `benchmark`, not `compile`,
    so `COMPILEONLY=true` checks nothing.
  - OCaml's `-O3` does nothing without flambda, which the local ocamlopt lacks.
  - The R note says x/y fall back to `numeric`, but they are `integer`.
  - The Rust README puts both binaries in one code block with inline comments
    instead of `###` headings, and the comments differ in punctuation
    (`Slower/Safe: ` vs `Faster/Unsafe; `).
  - The root README doesn't list the harness prerequisites: brew coreutils for
    `timeout`, and `npm install` for memory mode.
  - MODERNIZE.md says Kotlin has no native fixed-precision formatting with
    `String.format("%.3f", ...)`, but `kotlin/play.kt:47` uses exactly that.
  - IMPLEMENTATION.md has the typo "Lamdba", and its Array & Join form
    `[x, "-", y].join` differs from Ruby's `[x, y].join('-')`.
  - `helpers.sh` `SKIP=N` counts `node_modules/`.
  - The Nim comment has the typos "dont" and "To to".
  - Obj-C's string builder isn't preallocated.

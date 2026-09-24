# TODO

Findings from the 2026-09-24 scan, most severe first.

## Critical: memory safety and undefined behaviour

- [ ] 1. **objective-c** `main.m:16` and `benchmark.sh:7`: the only `@autoreleasepool` wraps the endless loop, so each tick's render string, keys and `UTF8String` buffers are never freed. The build also lacks `-fobjc-arc` while the code is written for ARC; unretained objects survive only because that pool never drains, and a probe that drains it segfaults. `node ../sample.js 30` graph: 7.4 MB at start, 19 MB at 5s, 40 MB at 15s, 51 MB at 20s (Max RSS 54.42 MB). RSS then drops to 16 MB as macOS compresses the dead pages, and `footprint` keeps counting them, so the one-number Max RSS hides the growth. A pool inside the loop body stays flat.
- [ ] 2. **fortran** `hashmap.f90:50`: the int32 FNV multiply overflows a signed integer (undefined behaviour). It works only because gfortran wraps; a `-ftrapv` build aborts at startup.
- [ ] 3. **rust (unsafe)** `world.rs:177-202`: possible undefined behaviour, raw pointers are still read while `values_mut()` writes. Unproven: Miri isn't installed.

## High: wrong benchmark numbers

- [ ] 4. **ocaml** `play.ml:25-35`, **fortran** `play.f90:42-52`, **lua** `play.lua:28-38`: they time with CPU time, not wall time. Lua has no sub-second wall clock, so it needs a README note rather than a fix.
- [ ] 5. **c++** `play.cpp:35-45`: `high_resolution_clock` is not monotonic with the README's `brew install gcc` (libstdc++). `steady_clock` fixes it.
- [ ] 6. **groovy** `benchmark.sh:7-8`: `groovy Play` recompiles Play from source as dynamic Groovy, so `--compile-static` never applies to the run loop.
- [ ] 7. **sql** `helpers.sh:65`: when Postgres is down, the panic trace's `main.main()` line passes the result grep and is reported as the benchmark result.
- [ ] 8. **dart** `play.dart:34-63`: times in whole microseconds where nanoseconds are available.

## Medium: wrong output or behaviour

- [ ] 9. **Empty `MINIMAL=`** still draws the board in go, sql, v, ballerina, nim, odin, perl and dlang. Ruby treats an empty value as set. Inko can't be fixed because its runtime drops empty variables.
- [ ] 10. **pony** `play.pony:19-35`: there is no initial render.
- [ ] 11. **sql** `play.go:69`: each frame is missing the last row's newline.
- [ ] 12. **odin** `play.odin:63`: `fmt.print` puts a space between `rendered` and `SHOW_SCREEN`.
- [ ] 13. **haskell** `World.hs:13` prints `LocationOccupied 1 2`, and **swift** `world.swift:10-17` prints `LocationOccupied(x: 1, y: 2)`. Both should print `LocationOccupied(1-2)`.
- [ ] 14. **nim** `play.nim:54-58`: every stats line ends with a trailing space.
- [ ] 15. **zig** `world.zig:27-35`: leaks memory if LocationOccupied is raised during init (never happens in a normal run).
- [ ] 16. **pony** `world.pony:92-101`: `_add_cell` on an occupied spot overwrites the cell and returns true. Nothing calls it that way today.
- [ ] 17. **dlang** `world.d:165-171`: `uint` coordinates make the `nx < 0` check dead code. The output is still correct.
- [ ] 18. **erlang** `world.erl:53-65` has no `if cell` guard in render. **fortran** `world.f90:92-94` advances `idx` outside its guard, and so does Julia's commented variant. None of these can trigger with a full grid.
- [ ] 19. **Two splits across the repo, to decide:**
  - About half the implementations add a blank line after the initial render, which Ruby's `puts` doesn't.
  - About half drop the newline that Ruby's `puts` adds after SHOW_SCREEN.

## Low: commented variants that break when uncommented

- [ ] 20. **fortran** `world.f90:72-84`: the string-concat render produces a corrupt frame.
- [ ] 21. **odin** `world.odin:82`: `tprintf` leaks, reaching 418 MB after 6 seconds.
- [ ] 22. **rust**: `.count()` and both `make_key` variants don't compile, in both the safe and unsafe versions.
- [ ] 23. **zig** `world.zig:106`: `makeKey` refers to an undeclared `allocator`.
- [ ] 24. **pony** `cell.pony:24-27`: the lambda variant doesn't compile. This form works: `Iter[Cell box](neighbours.values()).filter({(cell: Cell box): Bool => cell.alive }).count().u32()`.
- [ ] 25. **lisp** `world.lisp:93`: render's closing paren is attached to the active variant.
- [ ] 26. **ruby** `world.rb:52`: mutating `""` warns on Ruby 4 because string literals will become frozen.

## Low: inconsistencies

- [ ] 27. **Play type**: Scala removed it in 43e014b. Pony has everything in `Main`.
- [ ] 28. **Visibility**: helpers or constants that should be private are public in python, pony, odin, dlang, c++, ballerina, assemblyscript, clojure, dart, elixir and ruby. In F#, making them private fails at runtime.
- [ ] 29. **Types**:
  - Kotlin uses `Int` although `UInt` works.
  - F#'s `AliveNeighbours` returns `int`.
  - D uses 32-bit floats for timings.
  - TypeScript falls back to `alive` instead of false.
  - Zig uses `.?` where it could fall back with `orelse false`.
- [ ] 30. **Recorded rules**: AssemblyScript's `_f` and C's `min_double` use ternaries. Elixir `world.ex:143` inlines `make_key`.
- [ ] 31. **Labels**: Rust unsafe says "slowest", Crystal says "This following", V's end in a colon, and D's `cell.d:38` doesn't match Ruby. Inko's "slower" variant measured faster (unproven, the timings came from parallel runs).
- [ ] 32. **Docs and comments**:
  - The SQL README says one `UPDATE` per tick, but there are three.
  - SQLite's `init.sql` mentions autoanalyze, which SQLite doesn't have.
  - SQL's benchmark prints the CLI's SQLite version, not the one in the binary.
  - The Pony Notes don't use the standard wording.
  - `kotlin/benchmark.sh` prints "info: kotlinc-jvm" as its version header.
  - The Nim comment has the typos "dont" and "To to".
  - Obj-C's string builder isn't preallocated.

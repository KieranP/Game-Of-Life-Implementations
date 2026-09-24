# TODO

Findings from the 2026-09-24 scan, most severe first.

## Low: commented variants that break when uncommented

- [ ] 1. **fortran** `world.f90:84-96`: the string-concat render produces a
      corrupt frame.
- [ ] 2. **odin** `world.odin:91`: `tprintf` leaks, reaching 418 MB after 6
      seconds.
- [ ] 3. **rust**: `.count()` and both `make_key` variants don't compile, in
      both the safe and unsafe versions.
- [ ] 4. **zig** `world.zig:108`: `makeKey` refers to an undeclared
      `allocator`.
- [ ] 5. **pony** `cell.pony:24-27`: the lambda variant doesn't compile. This
      form works:
      `Iter[Cell box](neighbours.values()).filter({(cell: Cell box): Bool => cell.alive }).count().u32()`.
- [ ] 6. **lisp** `world.lisp:93`: render's closing paren is attached to the
      active variant.
- [ ] 7. **ruby** `world.rb:52`: mutating `""` warns on Ruby 4 because string
      literals will become frozen.

## Low: inconsistencies

- [ ] 8. **Play type**: Scala removed it in 43e014b. Pony has everything in
      `Main`.
- [ ] 9. **Visibility**: helpers or constants that should be private are public
      in python, pony, odin, dlang, c++, ballerina, assemblyscript, clojure,
      dart, elixir and ruby. In F#, making them private fails at runtime.
- [ ] 10. **Types**:
  - Kotlin uses `Int` although `UInt` works.
  - F#'s `AliveNeighbours` returns `int`.
  - D uses 32-bit floats for timings.
  - TypeScript falls back to `alive` instead of false.
  - Zig uses `.?` where it could fall back with `orelse false`.
- [ ] 11. **Recorded rules**: AssemblyScript's `_f` and C's `min_double` use
      ternaries. Elixir `world.ex:143` inlines `make_key`.
- [ ] 12. **Labels**: Rust unsafe says "slowest", Crystal says "This following",
      V's end in a colon, and D's `cell.d:38` doesn't match Ruby. Inko's
      "slower" variant measured faster (unproven, the timings came from parallel
      runs).
- [ ] 13. **Docs and comments**:
  - The SQL README says one `UPDATE` per tick, but there are three.
  - SQLite's `init.sql` mentions autoanalyze, which SQLite doesn't have.
  - SQL's benchmark prints the CLI's SQLite version, not the one in the binary.
  - The Pony Notes don't use the standard wording.
  - `kotlin/benchmark.sh` prints "info: kotlinc-jvm" as its version header.
  - The Nim comment has the typos "dont" and "To to".
  - Obj-C's string builder isn't preallocated.

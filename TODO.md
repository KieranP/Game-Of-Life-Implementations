# TODO

Findings from the 2026-09-24 scan, most severe first.

## Low: inconsistencies

- [ ] 1. **Play type**: Scala removed it in 43e014b. Pony has everything in
      `Main`.
- [ ] 2. **Visibility**: helpers or constants that should be private are public
      in python, pony, odin, dlang, c++, ballerina, assemblyscript, clojure,
      dart, elixir and ruby. In F#, making them private fails at runtime.
- [ ] 3. **Types**:
  - Kotlin uses `Int` although `UInt` works.
  - F#'s `AliveNeighbours` returns `int`.
  - D uses 32-bit floats for timings.
  - TypeScript falls back to `alive` instead of false.
  - Zig uses `.?` where it could fall back with `orelse false`.
- [ ] 4. **Recorded rules**: AssemblyScript's `_f` and C's `min_double` use
      ternaries. Elixir `world.ex:143` inlines `make_key`.
- [ ] 5. **Labels**: Rust unsafe says "slowest", Crystal says "This following",
      V's end in a colon, and D's `cell.d:38` doesn't match Ruby. Inko's
      "slower" variant measured faster (unproven, the timings came from parallel
      runs).
- [ ] 6. **Docs and comments**:
  - The SQL README says one `UPDATE` per tick, but there are three.
  - SQLite's `init.sql` mentions autoanalyze, which SQLite doesn't have.
  - SQL's benchmark prints the CLI's SQLite version, not the one in the binary.
  - The Pony Notes don't use the standard wording.
  - `kotlin/benchmark.sh` prints "info: kotlinc-jvm" as its version header.
  - The Nim comment has the typos "dont" and "To to".
  - Obj-C's string builder isn't preallocated.

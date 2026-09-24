# TODO

Findings from the 2026-09-24 scan, most severe first.

## Medium: wrong output or behaviour

- [ ] 1. **Empty `MINIMAL=`** still draws the board in go, sql, v, ballerina,
      nim, odin, perl and dlang. Ruby treats an empty value as set. Inko can't
      be fixed because its runtime drops empty variables.
- [ ] 2. **pony** `play.pony:19-35`: there is no initial render.
- [ ] 3. **sql** `play.go:69`: each frame is missing the last row's newline.
- [ ] 4. **odin** `play.odin:64`: `fmt.print` puts a space between `rendered`
      and `SHOW_SCREEN`.
- [ ] 5. **haskell** `World.hs:13` prints `LocationOccupied 1 2`, and **swift**
      `world.swift:10-17` prints `LocationOccupied(x: 1, y: 2)`. Both should
      print `LocationOccupied(1-2)`.
- [ ] 6. **nim** `play.nim:54-58`: every stats line ends with a trailing space.
- [ ] 7. **zig** `world.zig:27-35`: leaks memory if LocationOccupied is raised
      during init (never happens in a normal run).
- [ ] 8. **pony** `world.pony:92-101`: `_add_cell` on an occupied spot
      overwrites the cell and returns true. Nothing calls it that way today.
- [ ] 9. **dlang** `world.d:165-171`: `uint` coordinates make the `nx < 0` check
      dead code. The output is still correct.
- [ ] 10. **erlang** `world.erl:53-65` has no `if cell` guard in render.
      **fortran** `world.f90:104-106` advances `idx` outside its guard, and so
      does Julia's commented variant. None of these can trigger with a full
      grid.
- [ ] 11. **Two splits across the repo, to decide:**
  - About half the implementations add a blank line after the initial render,
    which Ruby's `puts` doesn't.
  - About half drop the newline that Ruby's `puts` adds after SHOW_SCREEN.

## Low: commented variants that break when uncommented

- [ ] 12. **fortran** `world.f90:84-96`: the string-concat render produces a
      corrupt frame.
- [ ] 13. **odin** `world.odin:91`: `tprintf` leaks, reaching 418 MB after 6
      seconds.
- [ ] 14. **rust**: `.count()` and both `make_key` variants don't compile, in
      both the safe and unsafe versions.
- [ ] 15. **zig** `world.zig:106`: `makeKey` refers to an undeclared
      `allocator`.
- [ ] 16. **pony** `cell.pony:24-27`: the lambda variant doesn't compile. This
      form works:
      `Iter[Cell box](neighbours.values()).filter({(cell: Cell box): Bool => cell.alive }).count().u32()`.
- [ ] 17. **lisp** `world.lisp:93`: render's closing paren is attached to the
      active variant.
- [ ] 18. **ruby** `world.rb:52`: mutating `""` warns on Ruby 4 because string
      literals will become frozen.

## Low: inconsistencies

- [ ] 19. **Play type**: Scala removed it in 43e014b. Pony has everything in
      `Main`.
- [ ] 20. **Visibility**: helpers or constants that should be private are public
      in python, pony, odin, dlang, c++, ballerina, assemblyscript, clojure,
      dart, elixir and ruby. In F#, making them private fails at runtime.
- [ ] 21. **Types**:
  - Kotlin uses `Int` although `UInt` works.
  - F#'s `AliveNeighbours` returns `int`.
  - D uses 32-bit floats for timings.
  - TypeScript falls back to `alive` instead of false.
  - Zig uses `.?` where it could fall back with `orelse false`.
- [ ] 22. **Recorded rules**: AssemblyScript's `_f` and C's `min_double` use
      ternaries. Elixir `world.ex:143` inlines `make_key`.
- [ ] 23. **Labels**: Rust unsafe says "slowest", Crystal says "This following",
      V's end in a colon, and D's `cell.d:38` doesn't match Ruby. Inko's
      "slower" variant measured faster (unproven, the timings came from parallel
      runs).
- [ ] 24. **Docs and comments**:
  - The SQL README says one `UPDATE` per tick, but there are three.
  - SQLite's `init.sql` mentions autoanalyze, which SQLite doesn't have.
  - SQL's benchmark prints the CLI's SQLite version, not the one in the binary.
  - The Pony Notes don't use the standard wording.
  - `kotlin/benchmark.sh` prints "info: kotlinc-jvm" as its version header.
  - The Nim comment has the typos "dont" and "To to".
  - Obj-C's string builder isn't preallocated.

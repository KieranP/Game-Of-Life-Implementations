In a subagent per implementation, list (don't apply) code that could use newer
idioms — but nothing that:
- adds ternaries/switch/match (only Cell#to_char), endless/expression bodies, or
  combined/flattened `if`s
- changes make_key's `key` local, Odin param groups, C/C++ `auto`, F# `<> null`,
  or `unless minimal` on its own line
- removes commented-out-code imports (grep first), tuple/Pair DIRECTIONS,
  `existing`, `_f`, Play/World/Cell, or Kotlin `public`
- breaks add_cell→bool, optional next_state, or the active "fastest" variant
- reformats untouched code, drops struct trailing commas, or skips updating
  commented render/alive_neighbours variants (see AGENTS.md/IMPLEMENTATION.md)

Won't compile / not an improvement — don't propose:
- AssemblyScript: no `Map` get-or-null (`Map.getOrNull`); unsigned cast breaks the negative-offset bounds check (`<u32>dir[0]`).
- Ballerina: no `??` null-coalescing (`x ?? false`); `+=` doesn't preserve `int:Unsigned32` (`self.tick += 1`).
- Fortran: `pure` only works on `make_key` (`pure function cell_at`).
- Groovy: no for-header destructuring (`for ((rel_x, rel_y) in DIRECTIONS)`).
- Inko: can't call an ownership-taking method on a borrowed field (`cell.next_state.or(false)`).
- Kotlin: no native fixed-precision float formatting (`String.format("%.3f", ...)`).
- Navi: no for-header destructuring (`for (let [rel_x, rel_y] in DIRECTIONS)`).
- OCaml: `Random.self_init` not deprecated.
- Odin: `or_else` needs the `.?` assertion (`next_state or_else false`).
- Perl: n-at-a-time `foreach` doesn't fit list-of-pairs DIRECTIONS (`foreach my ($rel_x, $rel_y) (...)`).
- Pony: no optional shorthand (`Bool?`); named args need `where`; no `+=` (`x += 1`).
- SQL: SQLite `generate_series` rejects a column alias (`generate_series(...) AS gx(value)`).
- V: no `os` env-presence check (`os.is_env_set`); optional map lookup needs `or {}`; no infinity literal (`math.inf(1)`).
- Zig: can't bit-cast `i96` to 64-bit (`@bitCast` to `u64`).

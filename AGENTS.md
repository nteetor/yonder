# yonder

## Documenting

- Rebuild the package namespace and documentation with `devtools::document()`. 
- Run roxygen examples with `devtools::run_examples()`.

## Checking (R CMD check)

- Check the package with `devtools::check()`

## Testing

- Run the R suite with `Rscript -e 'devtools::test()'` (or `devtools::test()` in
  the session). Scope a run with `devtools::test(filter = "multi-select")`.
- The client-side DOM harness is separate: `npm run test-dom`
  regenerates the R-rendered fixtures (`srcts/tests/gen-html.R`) and
  runs `srcts/tests/test-bindings.mjs` in jsdom.
- Both the harness and e2e load the committed bundles in `inst/www/` —
  run `npm run build` first whenever `srcts/` or the SCSS changed.

## Code design and style

- Wrap lines at width 80. Fill comments and roxygen text out to column 80
  before breaking — don't wrap early.

- Comments for exported or user-facing functions need to document purpose,
  arguments, return value. 

- Keep internal function comments terse. Do not add comments which simply
  reiterate what the code does.

- Comments explain constraints the code cannot show (cross-system contracts,
  casts, traps) — never the history of a change or how it compares to what it
  replaced.

## CSS

### Bootstrap classes

- When a custom component needs a Bootstrap component's look, style our
  own class from Bootstrap variables/tokens (`--bs-*`, Sass vars like
  `$input-focus-*`) rather than adding the Bootstrap component class
  (e.g. `.form-control`). Component classes carry layout assumptions
  (display, single-line heights, padding) that fight custom layouts;
  the variables give the same visual surface without the baggage.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:970c3bf2 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   bd dolt push
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->

## OpenSpec

Changes here use the `soroban` schema. Implement them with `soroban-apply`
and archive them with `soroban-archive` — including when `/opsx:apply` or
`/opsx:archive` is invoked. When unsure of a change's schema, check
`schemaName` in `openspec status --change <name> --json` before choosing.

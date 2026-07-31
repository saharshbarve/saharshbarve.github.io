# Personal site — working rules

Hand-written static site. `src/` is published verbatim; there is no build step,
no framework, and no generator. Keep it that way — the previous incarnation was
Jekyll + al-folio and was replaced specifically to remove that layer.

## Hard rules

1. **Never commit to `main`.** Branch-protected server-side and blocked by
   `.githooks/pre-push`. Branch → PR → review the preview → merge.
2. **Run `./scripts/validate.sh` before pushing.** It catches broken local
   references, which are otherwise invisible until they 404 in production.
3. **Look at the page.** `./scripts/serve.sh`, then check light *and* dark, and
   at least one narrow viewport.
4. **No build tooling, no dependencies, no CDN.** If something needs npm, the
   answer is almost certainly no.
5. **Never invent facts.** Publication authors come from Crossref/arXiv, repo
   metadata from the GitHub API, affiliations from the resume. Verify, don't
   recall.

## Theme

Light is the **product default** — the OS `prefers-color-scheme` is deliberately
*not* followed, so every first visit lands on the light design. Dark is opt-in
via the toggle and persists in `localStorage`.

Each page carries a small **inline** script in `<head>` that applies the saved
theme before first paint. Without it, a returning dark-mode visitor sees a white
flash. If you add a page, copy that script — `validate.sh` enforces it.

Colours live in `:root` (light) and `:root[data-theme="dark"]`. Never hardcode a
colour outside those blocks; every component reads a token.

## Layout

- `.wrap` is the single width constraint (`--measure`, 62rem). Don't add ad-hoc
  max-widths.
- The intro is a two-column grid, portrait right. Below 46rem it stacks and the
  portrait takes `order: -1` — without that it stranded itself below the
  affiliation pills at the very bottom.
- Affiliation pills accept either an `<img class="affiliation__logo">` or a
  `<span class="affiliation__mono">` monogram. Manipal and Onward Assist only
  publish 16×16 favicons, so they use monograms; swap in real logos if better
  artwork turns up.

## Motion

Compositor-friendly properties only — `transform`, `opacity`, `border-color`.
Everything is disabled under `prefers-reduced-motion`.

## Nav

`about` · `repositories` · `resume`, plus the theme toggle. `resume` is a direct
link to the PDF with `target="_blank"` so it opens in the browser's own viewer.
All three appear on every page and `validate.sh` enforces that.

## Publishing

Pages serves the **`gh-pages`** branch, which is written only by CI:

| Workflow | Trigger | Effect |
|---|---|---|
| `deploy.yml` | push to `main` | site → `gh-pages` root (preserves `preview/`) |
| `preview.yml` | PR opened/updated | site → `gh-pages:preview/pr-N/`, comments the link |
| `preview-cleanup.yml` | PR closed | deletes that preview |

`deploy.yml` deletes the root but explicitly skips `preview/` — a plain wipe
would take every open PR's preview down with it.

`.nojekyll` is written on deploy. Without it Pages runs the content through
Jekyll and silently drops `_`-prefixed paths.

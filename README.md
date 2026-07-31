# saharshbarve.github.io

Personal site — hand-written static HTML/CSS/JS. No Jekyll, no theme, no build step.

```
src/                    everything published, verbatim
├── index.html          about + publications
├── repositories.html   open source + projects
└── assets/
    ├── css/main.css    design tokens + components
    ├── js/theme.js     light/dark toggle
    ├── js/stars.js     live star counts (progressive enhancement)
    ├── img/            portrait + affiliation logos
    └── resume/         saharsh_barve_resume.pdf  ← the "resume" nav link
scripts/
├── serve.sh            local preview
└── validate.sh         broken-link and structure checks
```

## Local

```bash
./scripts/serve.sh          # http://localhost:4321
./scripts/validate.sh       # what CI runs
```

## Changing something

```bash
git switch -c edit/what-changed
# edit src/…
./scripts/serve.sh          # look at it
git commit -am "edit: ..."
git push -u origin edit/what-changed
gh pr create --fill
```

CI validates the change and publishes a **browsable preview** at
`https://saharshbarve.github.io/preview/pr-<N>/`, then comments the link on the
PR. Review the real rendered pages, then merge — merging to `main` publishes the
live site. Closing the PR deletes its preview.

## Why you can't push to main

1. **`.githooks/pre-push`** — refuses a local push targeting `main`.
   Enable once per clone: `git config core.hooksPath .githooks`
2. **Branch protection** — refuses it server-side even if the hook is bypassed.

## How publishing works

Pages serves the **`gh-pages`** branch. `main` holds the source; workflows copy
`src/` into `gh-pages` — the site at the root, PR previews under `preview/pr-N/`.
Nothing is hand-edited on `gh-pages`.

## Updating the resume

The PDF is built in the private [`resume`](https://github.com/saharshbarve/resume)
repo. Copy the latest build over and open a PR:

```bash
cp ../resume/saharsh_barve_resume_*.pdf src/assets/resume/saharsh_barve_resume.pdf
```

The filename here is intentionally undated so the nav link never breaks.

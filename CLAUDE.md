# visittrellis.com

The public sales page for **Trellis** — the product built in the
`communities` repo (`~/work/communities`) — at **visittrellis.com**. Static
HTML/CSS/JS on GitHub Pages. No back end, no Rails, no database. The app
itself runs on Heroku at `app.visittrellis.com`; this site links into it and
never holds accounts or prices.

- **What it's for, what's decided, what content exists, the DNS cutover:**
  `~/work/culture_studio/ecosystem_docs/apps/communities/trellis_site.md`.
  Read it first.
- **Decisions** made while building: `docs/DECISIONS.md`, dated, newest last.
- **The product itself,** for facts and screenshots: `~/work/communities`
  (its `README.md`, and `docs/style-guide.md` for the look, which this site
  matches). Screenshots use made-up data, never a real organization's.
- **The sister site,** built the same way: `~/work/craftymachine.com`.
  Whichever is built first sets the pattern (`bin/build`, `bin/dev`,
  `bin/deploy`); the other copies it.
- **House conventions:** `~/work/culture_studio/ecosystem_docs/RAILS_BOOTSTRAP.md`.
  The parts that apply here: Ruby 3.4.13, Tailwind via the standalone binary,
  no Node, bare-bones JS, Ruby `bin/` scripts, README shape, and
  **Git: stage, don't commit**. The Rails, Postgres and Heroku parts don't
  apply.

## Working here

- Port **4008** for the local preview (`bin/dev`). Keep it in sync with the
  port table in `RAILS_BOOTSTRAP.md`.
- Source in `src/`, built output in `_site/` (gitignored). Never hand-edit
  `_site/`.
- `bin/build` → `_site/`; `bin/dev` → build, watch, serve; `bin/deploy` →
  checks, then publish to GitHub Pages (`--dry-run` supported).
- No npm, no bundler, no framework. A page that works without JavaScript is
  the default.
- Never change DNS records for visittrellis.com yourself. Mail is sent from
  this domain; the cutover is a checklist Sean runs (kickoff doc §9).

**Status:** first build 2026-11-20 (pages, `bin/` scripts, Pages workflow).
Not yet published: `docs/DEPLOY.md` lists the one-off steps and their state.

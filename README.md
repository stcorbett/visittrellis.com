# visittrellis.com

The public sales page for **Trellis**, a home for community organizations:
build and support a community, raise money, coordinate volunteers and
members, run events and surveys, and report on the work. The page says what
Trellis is, shows it, and sends people to sign up or sign in at
app.visittrellis.com. A static site with no back end, published on GitHub
Pages.

> **Status:** first build (2026-11-20): home, customers, terms and privacy
> pages, build scripts and the Pages workflow. Not yet published; the
> runbook is `docs/DEPLOY.md`.

## Stack

- Static HTML, written as ERB templates and rendered by a small Ruby script
- **Ruby** 3.4.5 (the ecosystem's pin) — build tooling only
- **Tailwind CSS** via the standalone binary (`tailwindcss-ruby`) — no Node
- Plain JavaScript modules, only where a page needs them
- **GitHub Pages**, custom domain `visittrellis.com`

## Architecture

**A site, not an app.** The product is the `communities` Rails app at
app.visittrellis.com. This repo shares nothing with it at runtime: no server,
no database, no sign-in. Sign-up and sign-in are links into the app; plans
and prices, when they exist, are links into `culture_studio`.

**Source and output are separate.** `src/` holds templates, CSS and JS;
`bin/build` renders everything into `_site/`, which is what GitHub Pages
serves. `_site/` is never committed by hand.

## Getting started

```sh
bundle install   # Ruby 3.4.5; installs the Tailwind binary and webrick
bin/dev          # builds, watches src/, serves http://localhost:4008
```

Pages are `src/pages/**/*.html.erb`; each starts with
`<% page title: "…", description: "…" %>` and uses `path("terms/")` for
links between pages. Shared facts (app URLs, contact address, company)
live in `src/site.rb`.

## Tests

`bin/deploy --dry-run` builds and runs `bin/check` without publishing:
every internal link resolves, every page has a title and description, no
templates leak into the output, and `CNAME` is right.

## Deploying

```sh
bin/deploy
```

Pushes `main`; `.github/workflows/pages.yml` builds and publishes it. The
one-off GitHub Pages and DNS setup is in `docs/DEPLOY.md`.

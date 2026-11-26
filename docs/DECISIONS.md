# Decisions

Choices for visittrellis.com that the kickoff doc
(`~/work/culture_studio/ecosystem_docs/apps/communities/trellis_site.md`)
didn't settle, dated, newest last, each with the reason.

---

## 2026-11-20 — A static site in its own public repo

The kickoff doc has the reasoning (§4): the app already lives on
`app.visittrellis.com`, so the apex can be a GitHub Pages site without moving
anything, and the sales page and the app then ship and fail separately.

It gets its own repo, `stcorbett/visittrellis.com`, rather than living in
`communities` or `culture_studio`: GitHub Pages serves one site per repo and,
on the free plan, only from a public one, and both of those repos stay
private.

**Port 4008** for the local preview, the next free one after
craftymachine.com's 4007.

## 2026-11-20 — Publish with a GitHub Actions Pages workflow, not a `gh-pages` branch

`bin/deploy` builds and checks locally, then pushes `main`;
`.github/workflows/pages.yml` rebuilds on GitHub and deploys. What's live is
then always exactly what's on `main`, a deploy can't publish uncommitted work,
and there is no second branch of built files to keep in step. The cost is
that CI needs Ruby and the Tailwind gem, which `ruby/setup-ruby` caches.
craftymachine.com should copy this (its `bin/deploy` doesn't exist yet).

## 2026-11-20 — A Gemfile, for the build tools only

`tailwindcss-ruby` (the standalone Tailwind binary) and `webrick` (the local
server; no longer in Ruby's standard library). Bundler pins them for CI;
locally the scripts run with or without `bundle exec`.

## 2026-11-20 — Relative links between pages

The build writes `../terms/` rather than `/terms/`, so the same output works
at the `stcorbett.github.io/visittrellis.com/` preview and at the domain.
The 404 page is the one exception: GitHub serves it at any path, so it links
from `/` and only works on the domain.

## 2026-11-20 — Fonts self-hosted; nothing loaded from third parties

Fraunces and Nunito (the app's fonts) are copied into `src/static/assets/fonts`
as latin-subset variable woff2 files, instead of loaded from Google Fonts.
The privacy policy can then say truthfully that this site makes no
third-party requests (kickoff §10, no tracking).

## 2026-11-20 — Pages: home, customers, terms, privacy

- **Headline:** "Empowering you to create in community", with the app's
  "A warm, modern home for community organizations" above it.
- **Benefits lead:** low cost to the organization and a secure platform,
  first after the hero, per Sean's notes.
- **Customers page** talks about the kinds of organizations on Trellis and
  how we work with them, with no names, logos, counts or quotes (kickoff §5:
  only with permission; claims must be true). It explains why there are no
  logos and offers an introduction instead.
- **Terms and privacy** are plain-language drafts in the shape of
  Gmail's and Zeffy's (you keep your data and your contacts; we never market
  to them), with the hosted-only rule spelled out: the software is one shared
  platform under privacy commitments to many organizations, so running your
  own instance is a custom consulting engagement. They need a lawyer's review
  before launch.
- **No screenshots yet.** The kickoff wants screens from a development
  database with made-up data; they come in a later session.

## 2026-11-21 — "Shaped around how you work" is the pitch; free for community organizations

- **Positioning:** Trellis is a deeply customizable system for community
  organizations: your own data model (kinds of people, partners, places,
  items, events, workflows, each with its own fields) and screens arranged
  around each job. Unlike big platforms, the customizing is done *with* the
  customer when they start: we build the extra tools their work needs, and
  what we build joins Trellis for every network. The home page gets a section
  saying so, and "Shape it with us" becomes a step in "How it starts". The
  site never names Salesforce or any other product.
- **Price:** "Free for community organizations" (Sean, 2026-11-21). The
  business model is a share of money raised through Trellis (tickets,
  donations). The terms say so in general form (§6: a fee may apply to
  payments Trellis handles, always shown before you turn it on); the sales
  copy just says free.
- **Governing law:** Delaware, where Crafty Machine LLC is organized, with
  Delaware courts as the venue.

# Deploying visittrellis.com

How the site gets from `main` to the web, and the one-off steps to set that
up. Each step says whether it's done. The kickoff doc (§9) has the reasoning;
this is the runbook.

## How a deploy works (once set up)

```sh
bin/deploy --dry-run   # build + checks, publishes nothing
bin/deploy             # build + checks, then `git push origin main`
```

Pushing `main` runs `.github/workflows/pages.yml`: GitHub builds `_site/`
on a clean machine (Ruby from `.ruby-version`, Tailwind from the Gemfile),
runs `bin/check`, and deploys it to Pages. What's live is always what's on
`main`; there is no `gh-pages` branch.

---

## What's there today (checked 2026-11-20)

| Name | Record | Value | Who uses it |
|---|---|---|---|
| `visittrellis.com` | A | `15.197.225.128`, `3.33.251.168` | **GoDaddy domain forwarding** → 301 to `https://app.visittrellis.com/` |
| `www` | A | same two addresses | same forwarding |
| `app` | CNAME | `protected-castle-rte7ujg2160iq4rythys8t38.herokudns.com` | the app (Heroku) — **don't touch** |
| `mail` | MX, TXT (SPF) | `smtp.us-west-1.mailertogo.net`, `v=spf1 include:_spf.mailertogo.net ~all` | Mailer To Go (`MAILERTOGO_DOMAIN=mail.visittrellis.com`) — **don't touch** |
| `_dmarc` | TXT | `v=DMARC1; p=quarantine; …` | mail — **don't touch** |
| `*._domainkey.mail` | DKIM | (not listed by `dig`; assume present) | mail — **don't touch** |

- **DNS is at GoDaddy** (nameservers `ns67/ns68.domaincontrol.com`).
- **The current apex redirect is GoDaddy's forwarding**, not Heroku: Heroku
  has only `app.visittrellis.com` attached (`heroku domains -a
  stcorbett-communities`). So kickoff §9 step 4 (removing the apex from
  Heroku) is not needed.
- **The apex has no MX record.** Mail is sent from `mail.visittrellis.com`,
  so nothing *receives* mail at `@visittrellis.com`. `hello@visittrellis.com`
  (the contact address in `src/site.rb`) bounces until a mailbox or
  forwarding is set up (see the optional step below).

---

## One-off setup

Do these in order. Each one is safe to stop after: nothing about the live
domain changes until step 5, and the app and mail are never touched.

### 1. Commit — *not done*

The work is staged. Review it and commit:

```sh
cd ~/work/visittrellis.com
git diff --cached          # review
git commit                 # message suggested in the session
```

### 2. Create the GitHub repo and push — *not done*

```sh
gh repo create stcorbett/visittrellis.com --public --source . --remote origin
git push -u origin main
```

Public, because GitHub Pages on the free plan only serves public repos.
Nothing in this repo is secret.

The push starts the "Publish to GitHub Pages" workflow. **Its first run will
fail at the deploy step**, because Pages isn't turned on yet. That's
expected; step 3 fixes it.

### 3. Turn on Pages, with GitHub Actions as the source — *not done*

```sh
gh api -X POST repos/stcorbett/visittrellis.com/pages -f build_type=workflow
gh workflow run pages.yml --repo stcorbett/visittrellis.com
gh run watch --repo stcorbett/visittrellis.com
```

(In the browser instead: the repo → **Settings → Pages → Build and
deployment → Source: GitHub Actions**, then **Actions → Publish to GitHub
Pages → Run workflow**.)

When the run is green, open the preview:
**https://stcorbett.github.io/visittrellis.com/**. Click through every
page, the footer links, and "Start your network" (it should land on the
app's sign-up form). Fix anything now; each push to `main` republishes.

### 4. Verify the domain for your GitHub account — *not done*

This stops anyone else's GitHub repo from claiming visittrellis.com.

1. Go to **https://github.com/settings/pages** (your *account* settings, not
   the repo's) → **Add a domain** → enter `visittrellis.com` → **Add domain**.
2. GitHub shows a TXT record. Copy its value.
3. In GoDaddy (**https://dcc.godaddy.com/** → **Domains** → `visittrellis.com`
   → **DNS** → **DNS Records** → **Add New Record**):

   | Type | Name | Value | TTL |
   |---|---|---|---|
   | TXT | `_github-pages-challenge-stcorbett` | *(the value GitHub showed)* | 1 hour |

   (GoDaddy adds `.visittrellis.com` to the name itself.)
4. Wait until this prints the value (usually a few minutes):
   `dig +short TXT _github-pages-challenge-stcorbett.visittrellis.com`
5. Back on GitHub, press **Verify**. Leave the TXT record in place for good.

### 5. Point the domain at GitHub Pages — *not done*

This is the moment visittrellis.com stops redirecting to the app and starts
showing the sales page. In GoDaddy, `visittrellis.com` → **DNS**:

1. **Turn off forwarding.** **Forwarding** tab → the forwarding on
   `visittrellis.com` (to `https://app.visittrellis.com`) → delete it. If
   there's also a forwarding on `www`, delete that too.
2. **DNS Records** tab. Delete any `A` records named `@` (GoDaddy's
   forwarding or "Parked" addresses such as `15.197.225.128` and
   `3.33.251.168`), and any `A` records named `www`.
3. **Add the apex records.** First check the addresses on GitHub's
   [Managing a custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-an-apex-domain)
   page; they have been these for years:

   | Type | Name | Value | TTL |
   |---|---|---|---|
   | A | `@` | `185.199.108.153` | 1 hour |
   | A | `@` | `185.199.109.153` | 1 hour |
   | A | `@` | `185.199.110.153` | 1 hour |
   | A | `@` | `185.199.111.153` | 1 hour |
   | AAAA | `@` | `2606:50c0:8000::153` | 1 hour |
   | AAAA | `@` | `2606:50c0:8001::153` | 1 hour |
   | AAAA | `@` | `2606:50c0:8002::153` | 1 hour |
   | AAAA | `@` | `2606:50c0:8003::153` | 1 hour |

4. **Point `www`.** If a `CNAME` named `www` exists (often pointing to `@`),
   edit it; otherwise add one:

   | Type | Name | Value | TTL |
   |---|---|---|---|
   | CNAME | `www` | `stcorbett.github.io` | 1 hour |

5. **Don't touch:** `app` (CNAME to Heroku), anything named `mail` (MX and
   TXT), `_dmarc`, anything containing `_domainkey`, the
   `_github-pages-challenge-stcorbett` TXT, and the NS and SOA records.
6. Tell GitHub the domain:

   ```sh
   gh api -X PUT repos/stcorbett/visittrellis.com/pages -f cname=visittrellis.com
   ```

   (or repo **Settings → Pages → Custom domain** → `visittrellis.com` →
   Save). With an Actions-deployed site this setting is what counts; the
   build's `CNAME` file just agrees with it. GitHub then redirects `www` to
   the apex, and the `github.io` preview to the domain.
7. Check DNS has moved (minutes, occasionally an hour):

   ```sh
   dig +short visittrellis.com A          # the four 185.199.x.153 addresses
   dig +short www.visittrellis.com        # stcorbett.github.io. then those addresses
   dig +short app.visittrellis.com CNAME  # unchanged: …herokudns.com.
   dig +short mail.visittrellis.com MX    # unchanged: smtp.us-west-1.mailertogo.net.
   ```

### 6. Turn on HTTPS — *not done*

GitHub requests a certificate once DNS points at it; this takes from a few
minutes to about an hour. Until then `https://visittrellis.com` may show a
certificate warning. Repo **Settings → Pages** shows progress; when the
**Enforce HTTPS** box can be ticked, tick it, or:

```sh
gh api -X PUT repos/stcorbett/visittrellis.com/pages -F https_enforced=true
```

If the box stays greyed out after an hour, clear the custom domain, save,
and set it again; that restarts the certificate request.

### 7. Check — *not done*

- `https://visittrellis.com` and `https://www.visittrellis.com` show the
  sales page; `http://` versions redirect to `https://`.
- `https://visittrellis.com/nope` shows the Trellis 404 page.
- `https://app.visittrellis.com` still signs in.
- Request a password reset in the app: the email arrives and its link works.

Write the date next to each step in this file as it's done.

### Optional: a mailbox for hello@visittrellis.com

The site's contact address bounces today, because the apex has no MX record.
Any forwarding service works (GoDaddy's own email forwarding, ImprovMX,
Forward Email, or Google Workspace for a real mailbox). Each tells you to add
**MX records on `@`** and usually an **SPF TXT on `@`**. Both are safe:
sending from the app uses `mail.visittrellis.com`, which has its own MX and
SPF, and the DMARC policy is relaxed (`aspf=r`), so it keeps passing.
Don't edit the existing `_dmarc` record or anything under `mail`.

## Before it goes public

- **The app's own pages should say "Trellis"** (kickoff §2). Today the app's
  `<title>` and its sign-up redirect notice still say "Communities".
- **A mailbox for `hello@visittrellis.com`** (optional step above), or
  change `Site::CONTACT_EMAIL` in `src/site.rb`.
- **Terms and privacy reviewed by a lawyer.** They're plain-language drafts.

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

The personal CV site served at https://chepeftw.com: a single static page built with Astro. There is no test suite and no linter; `npm run check` (type-checks `.astro` files and the JSON imports) plus `npm run build` are the validation steps, and they are exactly what the PR workflow runs.

## Commands

- `docker compose up`: dev server with hot reload at http://localhost:4321
- `docker compose --profile prod up --build prod`: production build served by nginx at http://localhost:8486
- `npm run dev` / `npm run build` / `npm run preview`: same without Docker (build output goes to `dist/`)
- `npm run check`: `astro check`

## Architecture

- All CV content lives in `src/data/*.json` (profile, experiences, publications, conferences, educations, skills, languages, interests). Updating the CV means editing these files, not the page.
- `src/pages/index.astro` is the only page. It imports every JSON file and renders the sections in order using `src/components/Section.astro` (card + heading) and `src/components/Entry.astro` (title / meta / time row, reused by experience, publications, conferences and education).
- `src/layouts/Base.astro` holds the `<head>`, the light/dark toggle button and its script. Theme is driven by a `data-theme` attribute on `<html>`, persisted in `localStorage`, and falls back to `prefers-color-scheme`. An inline script in `<head>` applies the saved theme before first paint, so keep it inline and in the head.
- All styling is hand-written in `src/styles/global.css` using CSS variables for the light/dark palettes. There is no CSS framework and no web fonts.
- `public/` is copied as-is (`me.jpeg`, `favicon.ico`).

## Data shape gotchas

- `experiences[].details` is an array of strings. The page renders it as a bullet list when it has more than one item and a paragraph otherwise.
- `skills.json` is an array of `{ category, items[] }` groups, rendered as tags (no proficiency levels).
- Publications carry separate `title`, `authors`, `url`, `date`, `venue` fields (the old Jekyll data had HTML links embedded in the title).
- The Credly certification badges are hard-coded in `index.astro` (`badges` array of Credly badge IDs). Their embed script is lazy-loaded with an `IntersectionObserver` (600px margin); the `.badges` min-height reserves space to avoid layout shift.

## CI / deploy

- `.github/workflows/validate-pr.yaml`: on every pull request, runs `npm ci`, `npm run check`, `npm run build` and asserts `dist/index.html` exists.
- `.github/workflows/deploy-website.yaml`: on push to `master` (or manual dispatch), builds and runs `aws s3 sync --delete ./dist` to the site bucket, authenticating through the repo's scoped IAM role via OIDC. Merging to `master` therefore deploys to production immediately.

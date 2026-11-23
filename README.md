# Online CV

Source of [chepeftw.com](https://chepeftw.com), built with [Astro](https://astro.build).

## Content

All content lives in [src/data/](src/data/) as JSON files (profile, experiences, publications, conferences, education, skills, languages, interests). Edit those and the page updates.

## Local development

With Docker (hot reload, http://localhost:4321):

    docker compose up

Production build served by nginx, as it will be deployed (http://localhost:8486):

    docker compose --profile prod up --build prod

Without Docker:

    npm install
    npm run dev

## Deploy

Pushing to `master` runs [the workflow](.github/workflows/deploy-website.yaml), which builds the site and syncs `dist/` to S3.

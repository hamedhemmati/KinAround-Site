# KinAround public site

Static pages for GitHub Pages. No backend, package installation, JavaScript,
analytics, or build step is required.

The header and home page use KinAround's approved family-heart SVG, copied from
the app's production brand artwork. PNG browser and Apple touch icons are
resized from the production app icon. All artwork is local under `assets/`.

## Before publishing

The pages are grounded in the app code reviewed on October 19, 2026.
Developer: **Hamed Hemmati**. Public support/privacy email: **help@lowgear.ai**.
Family-use language requires guardian involvement and applicable consent, plus
Apple account/service eligibility; it does not invent a blanket minimum age.
Confirm the supported launch regions and requirements before release.

Confirm the wording against the final app and service configuration. In
particular:

1. Disclose the actual subscription or notification providers, their privacy
   links, and data handling if enabled. RevenueCat has not been assumed installed.
2. Choose and implement a retention policy. Current private movement history
   has no automatic expiry; do not claim a fixed deletion period without one.
   iCloud hosts the data, but the app still stores it. Circle records live in
   the owner's shared database, and notification signal metadata also uses the
   app's public CloudKit database. Do not claim everything is in a user's
   private iCloud or that signing out/uninstalling automatically removes it.
3. Finish in-app account deletion and update `delete-account/index.html` with
   the real steps and retention exceptions. A website request page does not
   implement account deletion in the app.
4. Confirm subscription features, prices/trial disclosures in the app, and
   Apple standard EULA selection. The site intentionally does not promise a
   particular price or that paid subscriptions are already available.
5. Review the policies for your actual business and launch regions, update the
   revision date, and remove every draft notice only when the pages are ready.

Keep this repository public **only for website content**. Do not copy app source,
credentials, Apple private keys, user data, or `.env` files into it.

## Publish using GitHub Free

1. Create a separate **public** repository, for example `KinAround-Site`.
2. Push this folder's site files to its default branch.
3. Open repository **Settings → Pages**.
4. Under **Build and deployment**, select **Deploy from a branch**.
5. Select your default branch (usually `main`) and **/ (root)**, then Save.
6. Wait for the Pages deployment and open the exact website URL GitHub displays.
   Confirm HTTPS and open every page without signing in.

`.nojekyll` tells Pages to serve these files directly. Relative asset and page
links work under the repository path; a custom domain is optional.

Replace `YOUR_USERNAME` below with your GitHub username and preserve the exact
repository spelling shown in GitHub's Pages URL:

| Purpose | Example URL |
| --- | --- |
| Home / marketing | `https://YOUR_USERNAME.github.io/KinAround-Site/` |
| Privacy policy | `https://YOUR_USERNAME.github.io/KinAround-Site/privacy/` |
| Terms | `https://YOUR_USERNAME.github.io/KinAround-Site/terms/` |
| Support | `https://YOUR_USERNAME.github.io/KinAround-Site/support/` |
| Data deletion | `https://YOUR_USERNAME.github.io/KinAround-Site/delete-account/` |

Use the published privacy and support URLs in App Store Connect. The app's
Info.plist expects HTTPS values for `KinAroundPrivacyURL` and `KinAroundTermsURL`.
These app settings are outside this site repository and are not changed here.

## Preview locally

From this folder:

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Open `http://127.0.0.1:8000/`. Stop the server with Control-C.

Check narrow and wide screens, keyboard navigation, each FAQ, and every link.
The layout uses system fonts, supports printing, and does not load third-party
assets. Hosting and external links can still process technical request data.

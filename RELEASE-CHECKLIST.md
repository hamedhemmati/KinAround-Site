# KinAround release status

Paid launch is not yet ready. This checklist separates implemented changes from
external configuration and device checks that have not been verified.

## App-side work completed

- Privacy, Terms, Support, Data & Deletion, and website links in Settings.
- Privacy and Terms before sign-in and on the membership screen.
- Account deletion with confirmation, cloud cleanup, interruption/retry handling,
  deletion-state protection against old-device restoration, and Watch controls.
- Matching build numbers across the app, Watch, and notification extension.
- Preference-access privacy manifests for all three targets.
- APNs entitlement environment follows Debug versus Release.
- Legal deletion page describes the implemented flow and retained-copy limits.

## Still required before paid launch

- Select and configure the production subscription verification service.
  The app currently configures its verifier as `nil`; production purchases and
  paid circle sponsorship are not active.
- Implement and validate owner entitlements, joined-circle sponsorship, Watch
  entitlements, renewals, cancellation, refunds, expiry, restore, offer codes,
  and provider-side account deletion.
- Update the privacy policy for the actual subscription provider.
- Deploy and verify the CloudKit production schema, including the private
  `UserProfile.accountDeletionState` String field and cleanup query indexes.
- Run the disposable-account scenarios in the app project's
  `Tests/AccountDeletionDeviceChecks.md`. Compilation and local isolation tests
  do not prove cloud deletion or permissions work on real accounts.
- Publish these updated site files and check the public page URLs.

## App Store Connect and submission

After app-side validation: agreements/tax/banking; subscription products, group,
trial and offer configuration; pricing and territories; app privacy disclosures;
age rating; screenshots and descriptions; support and privacy URLs; review
instructions; signed archive validation and upload; TestFlight purchase testing;
then submit the app and subscriptions for review.

App Store Connect configuration and the production CloudKit deployment have not
been inspected in this session.

# KinAround App Store assets

Five real app screens with fictional sample data: map, member details, places,
circles, and settings. Captured from an isolated simulator build of the actual
app, then composed with a cream background and short captions.

The sample circle is **The Parkers**: Alex, Jamie, and Sam Parker. Profile images
are stock portraits used with invented names, not actual KinAround users.
Their sources are listed in `portraits/SOURCES.md`. Home, Willow Library, and Maple School use
unrelated sample coordinates in San Francisco's Golden Gate Park. Apple's real
map labels remain visible; they are not claims about the fictional people's
addresses or actual school/library locations.

## Upload these first

In **App Previews and Screenshots**, upload the five numbered PNGs from:

| Platform | Folder | Pixels |
| --- | --- | --- |
| Large iPhone with Dynamic Island | `screenshots/iphone-dynamic-island-large` | 1320 × 2868 |
| 13-inch iPad | `screenshots/ipad-13` | 2064 × 2752 |
| Apple Watch Ultra | `screenshots/watch-ultra` | 422 × 514 |

The iPhone and iPad folders each contain five images. Watch contains three
native screenshots: map, member details, and family devices. Use the same Watch
screenshot dimensions across localizations, as Apple requires.

Apple scales the large iPhone/iPad screenshots for other display groups, so
uploading every optional folder is unnecessary. Keep the numbered order.

## Additional display-size exports

These use the genuine iPhone or iPad capture inside a marketing canvas matching
the indicated accepted dimensions. They are not fresh captures from each
legacy device. The screenshot itself is aspect-fitted, never stretched; its
outer corners follow the device screen mask.

The phone and tablet surrounds are original front-facing device mockups with
rounded screen corners, metallic rims, physical buttons, and soft shadows,
inspired by the [Screenhance reference](https://screenhance.com/device-frame-generator).
They are not official Apple bezels or reused Screenhance templates. The actual
status bar and Dynamic Island are part of the native iPhone capture.

| Folder | Pixels |
| --- | --- |
| `iphone-face-id-large` | 1284 × 2778 |
| `iphone-dynamic-island-medium` | 1206 × 2622 |
| `iphone-face-id-medium` | 1170 × 2532 |
| `iphone-home-button-large` | 1242 × 2208 |
| `iphone-home-button-medium` | 750 × 1334 |
| `ipad-12.9` | 2048 × 2732 |
| `ipad-11` | 1668 × 2420 |
| `ipad-10.5` | 1668 × 2224 |
| `ipad-9.7` | 1536 × 2048 |

Legacy dimensions are supplied as optional templates, not a promise that
KinAround supports those devices. The app requires iOS/iPadOS 17 or later.
Older 3.5-inch/4-inch iPhones cannot run it. No Mac, Apple TV, or visionOS
platform build is declared in this iOS project.

## iPhone Duo exports

Five images for each display are provided:

| Folder | Pixels | Capture source |
| --- | --- | --- |
| `screenshots/iphone-duo-outer` | 1398 × 2034 | Native iPhone capture |
| `screenshots/iphone-duo-inner` | 2007 × 2853 | Native iPad capture |

These are marketing exports in Apple's accepted Duo canvas dimensions, using
the existing phone/tablet device mockups and genuine app screens. They are not
native Duo screenshots and do not establish Duo optimization. The installed
Xcode has no Duo simulator device type. Review the app on a Duo simulator or
physical device before representing the native Duo layout as verified.

Apple's current specification says Duo screenshots become required in April
2027 for iOS 27.1 SDK builds. Uploading Duo screenshots adds an optimized-for-Duo
badge, so dimensions alone should not be treated as proof of device support.

## Header assets

The separate **Header and Search Results → Header** section shown in App Store
Connect accepts the two provided header alternatives:

- `headers/header-5244x2950.png`
- `headers/header-3840x1646.png`

Upload one header, not both. These are separate from app screenshots. No search
result-specific creative asset is included.

## Review and source

- `preview.png`: contact sheet of the five iPhone marketing images.
- `raw/`: native iPhone and iPad captures, without marketing captions. The PNG
  alpha channel is removed at the original pixel dimensions for upload.
- `capture-fixtures.patch`: sample-data changes applied only to a temporary copy
  of the app. Never apply this patch to a release build: it bypasses real account
  restoration and cloud refreshes for screenshot capture.
- `portraits/`: the stock sample-profile images and source links. The temporary
  Xcode project bundles these PNGs into both screenshot builds.
- `capture.py`, `capture-watch.py`: capture scripts for the temporary builds and
  simulator UUIDs used in this session.
- `compose.swift`: dependency-free AppKit image export script. Run
  `swift compose.swift /absolute/path/to/store-assets` to regenerate marketing
  exports from the raw captures.
- `validation.json`: dimensions and PNG color format checks.

The capture builds lived under `/tmp/kinaround-store-capture`, with separate
iOS and watchOS derived-data folders. The live app source and iCloud records
were not modified for this task. No screenshot has been uploaded or published.

Dimensions checked against Apple's
[Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
on October 19, 2026. All marketing screenshots and headers are opaque PNGs.

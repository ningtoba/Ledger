# Cashew → Ledger Full Transition Checklist

Everything that needs to change to make this fork fully independent.  
About ~69 items across 9 categories.

**Instructions:** Tick boxes as you complete each item. Items marked with 🔥 are blocking — do those first.

---

## 1. BRAND IDENTITY (App Name, Icons, Splash, Deep Links)

### App Display Names
- [x] 🔥 `budget/android/app/src/main/AndroidManifest.xml:33` — `android:label="Cashew"` → `"Ledger"`
- [x] 🔥 `budget/ios/Runner/Info.plist:12` — `"Cashew uses photos..."` → `"Ledger uses photos..."`
- [x] 🔥 `budget/ios/Runner/Info.plist:14` — `"Cashew uses the camera..."` → `"Ledger uses the camera..."`
- [x] 🔥 `budget/ios/Runner/Info.plist:22` — `CFBundleDisplayName = "Cashew"` → `"Ledger"`
- [x] 🔥 `budget/ios/Runner.xcodeproj/project.pbxproj` — 3x `INFOPLIST_KEY_CFBundleDisplayName = Cashew` → `Ledger`
- [x] `budget/ios/Runner/Info.plist:30` — `CFBundleName = "budget"` → `"Ledger"`

### App Icons (Android: 20 PNGs, iOS: 21 PNGs, Web: 4 files, Notification: 3 PNGs)
- [ ] **Source assets** — Replace `budget/assets/icon/logo.png` and `budget/assets/icon/icon-web.png` with new Ledger icon design before running `flutter pub run flutter_launcher_icons:main`
- [ ] **Android mipmaps** (auto-generated from logo.png via flutter_launcher_icons):
  - `budget/android/app/src/main/res/mipmap-mdpi/ic_launcher*.png` (4 files: png, foreground, background, monochrome)
  - `budget/android/app/src/main/res/mipmap-hdpi/ic_launcher*.png` (4 files)
  - `budget/android/app/src/main/res/mipmap-xhdpi/ic_launcher*.png` (4 files)
  - `budget/android/app/src/main/res/mipmap-xxhdpi/ic_launcher*.png` (4 files)
  - `budget/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher*.png` (4 files)
  - `budget/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (adaptive icon config)
- [ ] **Android notification icons**:
  - `budget/assets/icon/notification_icon_android.png`
  - `budget/assets/icon/notification_icon_android2.png`
  - `budget/android/app/src/main/res/drawable/notification_icon_android2.png`
- [ ] **iOS AppIcon assets** (auto-generated from logo.png):
  - `budget/ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png` (21 PNGs at various sizes)
- [ ] **Web PWA icons**:
  - `budget/web/icons/Icon-192.png`
  - `budget/web/icons/Icon.png`
  - `budget/web/icons/Icon-512.png`
  - `budget/web/favicon.ico`
  - `budget/web/favicon.png`

### Splash Screen
- [ ] `budget/android/app/src/main/res/drawable/launch_background.xml` — Currently just white background. Add Ledger logo (uncomment mipmap/launch_image reference)
- [ ] `budget/android/app/src/main/res/values/styles.xml` — Review LaunchTheme / NormalTheme colors
- [ ] `budget/ios/Runner/Base.lproj/LaunchScreen.storyboard` — Update LaunchScreen with Ledger branding (edit via Xcode)

### Deep Links / Universal Links
- [x] 🔥 `budget/android/app/src/main/AndroidManifest.xml:52-53` — `android:host="cashewapp.web.app"` → `ledger-626f4.web.app`
- [x] 🔥 `budget/ios/Runner/Runner.entitlements:9` — `applinks:cashewapp.web.app` → `ledger-626f4.web.app`
- [x] `budget/lib/widgets/util/appLinks.dart:388` — Comment referencing old domain (clean up)

---

## 2. DEVELOPER IDENTITY (Package Name, Bundle ID, Author Info)

### Package Name / Bundle ID
- [x] 🔥 `budget/android/app/build.gradle:44` — `applicationId "com.budget.tracker_app"` → `com.ningtoba.ledger`
- [x] 🔥 `budget/android/app/src/main/AndroidManifest.xml:2` — `package="com.budget.tracker_app"` → `com.ningtoba.ledger`
- [x] 🔥 `budget/android/app/src/debug/AndroidManifest.xml:2` — same
- [x] 🔥 `budget/android/app/src/profile/AndroidManifest.xml:2` — same
- [x] 🔥 `budget/ios/Runner.xcodeproj/project.pbxproj` — 3x `PRODUCT_BUNDLE_IDENTIFIER = "com.budget.tracker-app"` → `com.ningtoba.ledger`
- [x] 🔥 `budget/ios/Runner.xcodeproj/project.pbxproj` — test target bundle IDs → `com.ningtoba.ledger.RunnerTests`
- [x] 🔥 `budget/android/app/src/main/kotlin/.../*.kt` — 5 Kotlin files: `package com.budget.tracker_app` → `com.ningtoba.ledger` (+ moved to correct dir)
- [x] `budget/lib/firebase_options.dart:74` — `iosBundleId: 'com.budget.tracker-app'` → `com.ningtoba.ledger`

### Apple Developer
- [ ] `budget/ios/Runner.xcodeproj/project.pbxproj` — Replace `DEVELOPMENT_TEAM = HCL9V2D3XY` with YOUR team ID

### Author Info
- [x] `budget/lib/pages/aboutPage.dart:135-148` — "James" (lead dev) → "Luqman"
- [x] `budget/lib/pages/aboutPage.dart:116,119,144` — `dapperappdeveloper@gmail.com` → `luqmanhakim.dev@gmail.com`
- [x] `budget/lib/pages/premiumPage.dart:708-709` — `dapperappdeveloper@gmail.com` → `luqmanhakim.dev@gmail.com`
- [x] `budget/lib/struct/settings.dart:351,354,391` — `dapperappdeveloper@gmail.com` → `luqmanhakim.dev@gmail.com`
- [x] `budget/lib/pages/aboutPage.dart:193` — `"made-in-canada"` → `"vibe-in-malaysia"` (new translation key)
- [x] `budget/lib/pages/premiumPage.dart:1426` — `ko-fi.com/dapperappdeveloper` → removed (PremiumBanner now returns empty)
- [x] `README.md:164` — `dapperappdeveloper@gmail.com` → `luqmanhakim.dev@gmail.com`

---

## 3. FIREBASE & INFRASTRUCTURE

### Firebase Project Setup
- [x] 🔥 **Create your own Firebase project** (everything below depends on this)
- [x] 🔥 `budget/lib/firebase_options.dart` — Regenerated with `flutterfire configure`
- [x] 🔥 `budget/android/app/google-services.json` — Regenerated with `flutterfire configure`
- [x] 🔥 `budget/.firebaserc` — Updated to `ledger-626f4`
- [x] `budget/web/index.html:80-86` — Firebase config updated to `ledger-626f4` (apiKey needs real value from Firebase console)
- [x] `budget/firebase.json:8` — `"site":"budget-track"` → `"ledger-626f4"`
- [x] Delete `budget/android/app/google-services-old.json` (stale) — done
- [x] Delete `budget/android/app/google-services-laptop-dev.json` — done

### CI/CD
- [x] `.github/workflows/firebase-hosting-pull-request.yml:24-25` — Updated `projectId` to `ledger-626f4` and `firebaseServiceAccount` secret to `FIREBASE_SERVICE_ACCOUNT_LEDGER`
- [x] Set up GitHub secret `FIREBASE_SERVICE_ACCOUNT_LEDGER`

---

## 4. IN-APP PURCHASES

- [x] 🔥 `budget/lib/pages/premiumPage.dart` — Deleted entirely (1407 lines). All IAP code removed.
- [x] 🔥 `budget/lib/struct/defaultPreferences.dart` — Removed `purchaseID`, `premiumPopupAddTransactionCount`, `premiumPopupAddTransactionLastShown`, `premiumPopupFreeSeen` keys
- [x] 🔥 `budget/pubspec.yaml` — Removed `in_app_purchase: ^3.2.0` dependency
- [x] Removed IAP imports and premium popup calls from 11 files (navigationFramework, settings, defaultPreferences/settings, addTransactionPage, addObjectivePage, addBudgetPage, budgetPage, walletDetailsPage, selectColor)
- [x] Removed `FadeOutAndLockFeature` and `LockedFeature` widget wrappers (walletDetailsPage, selectColor)
- [x] Removed `PremiumBanner` from settings page (was already `SizedBox.shrink()`)
- [x] Removed 28 IAP translation keys across 46 language files + master CSV
- [x] `README.md` — Removed Payments row from stack table

---

## 5. USER-FACING CONTENT

### Exported File Names
- [x] `budget/lib/widgets/exportDB.dart:42` — `"cashew-"` → `"ledger-"`
- [x] `budget/lib/widgets/exportCSV.dart:155,172` — `"cashew-"` → `"ledger-"`
- [x] `budget/lib/widgets/importCSV.dart:834` — `"cashew-import-template"` → `"ledger-import-template"`
- [x] `budget/lib/widgets/accountAndBackup.dart:1518` — `"cashew-"` → `"ledger-"`

### External URLs (Cashew Domains)
- [x] `budget/lib/pages/aboutPage.dart:866` — `cashewapp.web.app/faq.html` → removed (no website yet)
- [x] `budget/lib/pages/aboutPage.dart:907` — `cashewapp.web.app/policy.html` → removed (no website yet)
- [x] `budget/lib/pages/accountsPage.dart:354` — `cashewapp.web.app/policy.html` → removed (Tappable stripped, text kept)
- [x] `budget/lib/pages/settingsPage.dart:110` — `cashewapp.web.app/faq.html` → removed (FAQ dropdown item removed)
- [x] `budget/lib/pages/premiumPage.dart:712` — `cashewapp.web.app/faq.html#restoring-purchases` → already gone (file deleted)
- [x] `budget/lib/widgets/importCSV.dart:245` — `cashewapp.web.app/faq.html#import-csv-data` → removed (help button set to null)
- [x] `budget/lib/widgets/ratingPopup.dart:127` — `cashewapp.web.app/faq.html` → removed (FAQ link removed)
- [x] `budget/web/index.html:43-52` — 4x OG/Twitter meta tags — removed `og:image` and `twitter:image` (no preview image hosted)

### Translations
- [ ] `budget/assets/translations/generated/no.json:475` — `"støtter cashew"` → `"støtter Ledger"`
- [ ] `budget/assets/translations/generated/sv.json:475` — `"stöder cashew"` → `"stöder Ledger"`
- [ ] Consider renaming translation key `"enjoying-cashew-question"` across all 30+ files

### Changelog
- [ ] `budget/lib/widgets/showChangelog.dart` — 6 historical entries reference "Cashew Pro" and "App rename to Cashew" — edit or leave as history

---

## 6. BUILD SYSTEM

- [ ] `budget/android/app/build.gradle:67-73` — Create YOUR OWN release keystore and `key.properties`
- [ ] `scripts/deploy_and_build_windows.bat` — Review for old references
- [ ] `scripts/open_release_builds.bat` — Review for old references
- [ ] `scripts/update_translations.bat` — Review for old references
- [ ] `budget/pubspec.yaml:75` — `reorderable_grid_view` points to `jameskokoska/reorderable_grid_view` — fork to your account

---

## 7. CODE CLEANUP

- [ ] `budget/lib/pages/aboutPage.dart:46,546,591` — Variable name `cashewInformation` → rename
- [ ] `budget/lib/pages/settingsPage.dart:185` — Commented-out GitHub link — clean up
- [ ] `budget/lib/widgets/util/appLinks.dart:388` — Commented-out Cashew domain — clean up
- [ ] `budget/android/app/src/main/AndroidManifest.xml:125-141` — Commented-out notification service XML — clean up
- [ ] `budget/pubspec.yaml:1` — `name: budget` → consider `ledger` (this controls Firebase web app nickname — change before re-running `flutterfire configure`)

---

## 8. GOOGLE SIGN-IN CLIENT IDS

- [ ] `budget/ios/Runner/Info.plist:69` — Replace `com.googleusercontent.apps.267621253497-...` with YOUR client ID
- [ ] `budget/lib/firebase_options.dart:72-73` — Replace `androidClientId` and `iosClientId` (auto-done by `flutterfire configure`)
- [ ] `budget/web/index.html:21` — Replace `google-signin-client_id` with YOUR web client ID

---

## 9. DEPENDENCY FORK

- [ ] Fork `jameskokoska/reorderable_grid_view` to your GitHub
- [ ] `budget/pubspec.yaml:75` — Update URL to your fork

---

## Quick Summary

| Priority | Count | What |
|----------|-------|------|
| 🔥 Must fix before build | ~15 | App names, bundle IDs, Firebase project |
| Should fix before release | ~20 | URLs, emails, icons, splash |
| Nice to have | ~15 | Comments, variable names, changelog |
| Delete/clean up | ~5 | Stale google-services files, dead comments |

---

## Critical Path (Recommended Order)

1. **Change package name / bundle ID** → Android manifests, build.gradle, iOS pbxproj, Kotlin files
2. **Update app display names** → AndroidManifest label, iOS Info.plist + pbxproj
3. **Create your Firebase project** → regenerate firebase_options.dart + google-services.json
4. **Replace app icons** → Android mipmaps, iOS AppIcon assets, web favicons
5. **Replace all external URLs** → FAQ, policy, social meta tags
6. **Update author info** → about page, email addresses, Ko-fi link
7. **Update exported file names** → DB, CSV, backup, import template
8. **Create new IAP products** → replace `cashew.pro.*` with your product IDs
9. **Clean up stale files** → old google-services JSONs, dead comments
10. **Update CI/CD** → Firebase service account, project ID

---

*Generated 2026-05-20 by automated full-repo scan.*

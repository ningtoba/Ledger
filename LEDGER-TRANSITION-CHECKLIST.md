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

### App Icons
- [ ] `budget/android/app/src/main/res/mipmap-*/ic_launcher*.png` — Replace 20+ Android icon PNGs with Ledger design
- [ ] `budget/ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png` — Replace 21 iOS icon PNGs
- [ ] `budget/web/icons/Icon-192.png`, `Icon-512.png` — Replace PWA icons
- [ ] `budget/web/favicon.ico`, `budget/web/favicon.png` — Replace favicons
- [ ] `budget/assets/icon/notification_icon_android.png`, `notification_icon_android2.png` — Replace notification icons

### Splash Screen
- [ ] `budget/android/app/src/main/res/drawable/launch_background.xml` — Add Ledger logo or keep clean
- [ ] `budget/ios/Runner/Base.lproj/LaunchScreen.storyboard` — Update LaunchImage with Ledger branding

### Deep Links / Universal Links
- [x] 🔥 `budget/android/app/src/main/AndroidManifest.xml:52-53` — `android:host="cashewapp.web.app"` → `ledger-626f4.web.app`
- [x] 🔥 `budget/ios/Runner/Runner.entitlements:9` — `applinks:cashewapp.web.app` → `ledger-626f4.web.app`
- [ ] `budget/lib/widgets/util/appLinks.dart:388` — Comment referencing old domain (clean up)

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
- [ ] `budget/lib/pages/aboutPage.dart:135-148` — "James" (lead dev) → your name
- [ ] `budget/lib/pages/aboutPage.dart:116,119,144` — `dapperappdeveloper@gmail.com` → your email
- [ ] `budget/lib/pages/premiumPage.dart:708-709` — `dapperappdeveloper@gmail.com` → your email
- [ ] `budget/lib/struct/settings.dart:351,354,391` — `dapperappdeveloper@gmail.com` → your email
- [ ] `budget/lib/pages/aboutPage.dart:193` — `"made-in-canada"` → update or keep
- [ ] `budget/lib/pages/premiumPage.dart:1426` — `ko-fi.com/dapperappdeveloper` → your support link
- [ ] `README.md:164` — `dapperappdeveloper@gmail.com` → your email

---

## 3. FIREBASE & INFRASTRUCTURE

### Firebase Project Setup
- [x] 🔥 **Create your own Firebase project** (everything below depends on this)
- [x] 🔥 `budget/lib/firebase_options.dart` — Regenerated with `flutterfire configure`
- [x] 🔥 `budget/android/app/google-services.json` — Regenerated with `flutterfire configure`
- [x] 🔥 `budget/.firebaserc` — Updated to `ledger-626f4`
- [ ] `budget/web/index.html:80-86` — Replace `budget-app-flutter` Firebase config with yours
- [ ] `budget/firebase.json:8` — `"site":"budget-track"` → your site or keep
- [ ] Delete `budget/android/app/google-services-old.json` (stale)
- [ ] Delete or replace `budget/android/app/google-services-laptop-dev.json`

### CI/CD
- [ ] `.github/workflows/firebase-hosting-pull-request.yml:24-25` — Update `projectId` and `firebaseServiceAccount` secret name for your Firebase project
- [ ] Set up GitHub secret `FIREBASE_SERVICE_ACCOUNT_LEDGER` (or whatever you name it)

---

## 4. IN-APP PURCHASES

- [ ] 🔥 `budget/lib/pages/premiumPage.dart:34-42` — Replace `cashew.pro.yearly`, `cashew.pro.monthly`, `cashew.pro.life`, `cashew.pro.lifetime` with YOUR product IDs
- [ ] 🔥 `budget/lib/pages/premiumPage.dart:486,489` — Update subscription management URLs with new SKU and package name

---

## 5. USER-FACING CONTENT

### Exported File Names
- [ ] `budget/lib/widgets/exportDB.dart:42` — `"cashew-"` → `"ledger-"`
- [ ] `budget/lib/widgets/exportCSV.dart:155,172` — `"cashew-"` → `"ledger-"`
- [ ] `budget/lib/widgets/importCSV.dart:834` — `"cashew-import-template"` → `"ledger-import-template"`
- [ ] `budget/lib/widgets/accountAndBackup.dart:1518` — `"cashew-"` → `"ledger-"`

### External URLs (Cashew Domains)
- [ ] `budget/lib/pages/aboutPage.dart:866` — `cashewapp.web.app/faq.html` → your URL
- [ ] `budget/lib/pages/aboutPage.dart:907` — `cashewapp.web.app/policy.html` → your URL
- [ ] `budget/lib/pages/accountsPage.dart:354` — `cashewapp.web.app/policy.html` → your URL
- [ ] `budget/lib/pages/settingsPage.dart:110` — `cashewapp.web.app/faq.html` → your URL
- [ ] `budget/lib/pages/premiumPage.dart:712` — `cashewapp.web.app/faq.html#restoring-purchases` → your URL
- [ ] `budget/lib/widgets/importCSV.dart:245` — `cashewapp.web.app/faq.html#import-csv-data` → your URL
- [ ] `budget/lib/widgets/ratingPopup.dart:127` — `cashewapp.web.app/faq.html` → your URL
- [ ] `budget/web/index.html:43-52` — 4x OG/Twitter meta tags pointing to `cashewapp.web.app/assets/preview.png` → your hosted preview

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

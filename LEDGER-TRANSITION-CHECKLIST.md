# Cashew → Ledger Transition Checklist

An exhaustive checklist of every remaining Cashew reference and branding gap that needs to be fixed for a complete Ledger transition.

---

## Priority Legend

| Icon | Meaning |
|------|---------|
| 🔥🔥 | **CRITICAL** — will crash at build or runtime |
| 🔥 | **MAJOR** — visible to users or affects functionality |
| ⚡ | **MINOR** — code quality / internal consistency |
| ℹ️ | **INFO** — intentional attribution, no action needed |

---

## 1. Android

- [ ] 🔥🔥 **`budget/android/app/src/main/AndroidManifest.xml:33`** — `android:label="Cashew"` → `"Ledger"` (app icon label on launcher)
- [ ] 🔥🔥 **`budget/android/app/src/main/AndroidManifest.xml:52-53`** — `android:host="cashewapp.web.app"` → your Ledger domain (deep link verification)
- [ ] 🔥 **`budget/android/app/build.gradle:44`** — `applicationId "com.budget.tracker_app"` → `"com.ledger.tracker"` (Play Store identity)
- [ ] 🔥 **`budget/android/app/src/main/AndroidManifest.xml:2`** — `package="com.budget.tracker_app"` → must match build.gradle
- [ ] 🔥 **`budget/android/app/src/debug/AndroidManifest.xml:2`** — same package
- [ ] 🔥 **`budget/android/app/src/profile/AndroidManifest.xml:2`** — same package
- [ ] ℹ️ **`budget/android/app/google-services.json`** — points to `budget-app-flutter` Firebase project. Either keep (if using that project) or regenerate for your own project.
- [ ] ℹ️ **`budget/android/app/google-services-laptop-dev.json`** — same question
- [ ] ℹ️ **`budget/android/app/google-services-old.json`** — same question
- [ ] ⚡ **`budget/android/app/src/main/kotlin/`** — check Kotlin files for any app name references

---

## 2. iOS

- [ ] 🔥🔥 **`budget/ios/Runner/Info.plist:12`** — `"Cashew uses photos..."` → `"Ledger uses photos..."` (photo library permission)
- [ ] 🔥🔥 **`budget/ios/Runner/Info.plist:14`** — `"Cashew uses the camera..."` → `"Ledger uses the camera..."` (camera permission)
- [ ] 🔥🔥 **`budget/ios/Runner/Info.plist:22`** — `CFBundleDisplayName = "Cashew"` → `"Ledger"` (iOS icon label)
- [ ] 🔥🔥 **`budget/ios/Runner/Runner.entitlements:9`** — `applinks:cashewapp.web.app` → your Ledger domain (universal links verification)
- [ ] 🔥 **`budget/ios/Runner/Info.plist:30`** — `CFBundleName = "budget"` → `"Ledger"`
- [ ] 🔥 **`budget/ios/Runner.xcodeproj/project.pbxproj:504,692,722`** — `PRODUCT_BUNDLE_IDENTIFIER = "com.budget.tracker-app"` → your new bundle ID
- [ ] ℹ️ **GoogleService-Info.plist** — if it exists, check Firebase project reference

---

## 3. Firebase & Backend

- [ ] 🔥🔥 **`budget/lib/firebase_options.dart`** — all 4 platform configs point to `budget-app-flutter`. Decide: keep old Firebase project or create new one
- [ ] 🔥🔥 **`budget/web/index.html:81-83`** — `authDomain`, `projectId`, `storageBucket` all say `budget-app-flutter` — same decision
- [ ] 🔥🔥 **`budget/.firebaserc:3`** — `"default": "budget-app-flutter"` → your Firebase project
- [ ] 🔥 **`.github/workflows/firebase-hosting-pull-request.yml:24-25`** — `projectId: budget-app-flutter`, `secrets.FIREBASE_SERVICE_ACCOUNT_BUDGET_APP_FLUTTER`
- [ ] 🔥 **`budget/android/app/google-services.json`** — `project_id: "budget-app-flutter"`, `package_name: "com.budget.tracker_app"`
- [ ] 🔥 **`budget/android/app/google-services-laptop-dev.json`** — same
- [ ] ℹ️ **`budget/android/app/google-services-old.json`** — stale backup, can delete

---

## 4. In-App Purchase Product IDs

> **Decision needed:** Are you shipping under a new app store entry or inheriting the Cashew listing?

- [ ] 🔥 **`budget/lib/pages/premiumPage.dart:35-42`** — `cashew.pro.yearly`, `cashew.pro.monthly`, `cashew.pro.life`, `cashew.pro.lifetime` — if publishing fresh, register new IAP products
- [ ] 🔥 **`budget/lib/pages/premiumPage.dart:486,489`** — `sku=cashew.pro.monthly` in Google Play subscription management URLs

---

## 5. Exported File Names

- [ ] 🥇 **`budget/lib/widgets/exportDB.dart:42`** — `"cashew-" + filename` → `"ledger-"`
- [ ] 🥇 **`budget/lib/widgets/exportCSV.dart:155,172`** — `"cashew-" + filename` → `"ledger-"`
- [ ] 🥇 **`budget/lib/widgets/accountAndBackup.dart:1518`** — `"cashew-" + backup name` → `"ledger-"`
- [ ] 🥇 **`budget/lib/widgets/importCSV.dart:834`** — `"cashew-import-template"` → `"ledger-import-template"`

---

## 6. External URLs (Pointing to Cashew Domains)

> These all point to `cashewapp.web.app` (the upstream developer's site). Replace with your own hosted pages if you have them, or remove the links.

- [ ] 🔥 **`budget/lib/pages/aboutPage.dart:866`** — `https://cashewapp.web.app/faq.html`
- [ ] 🔥 **`budget/lib/pages/aboutPage.dart:907`** — `https://cashewapp.web.app/policy.html`
- [ ] 🔥 **`budget/lib/pages/accountsPage.dart:354`** — `https://cashewapp.web.app/policy.html`
- [ ] 🔥 **`budget/lib/pages/settingsPage.dart:110`** — `https://cashewapp.web.app/faq.html`
- [ ] 🔥 **`budget/lib/pages/premiumPage.dart:712`** — `https://cashewapp.web.app/faq.html#restoring-purchases`
- [ ] 🔥 **`budget/lib/widgets/importCSV.dart:245`** — `https://cashewapp.web.app/faq.html#import-csv-data`
- [ ] 🔥 **`budget/lib/widgets/ratingPopup.dart:127`** — `https://cashewapp.web.app/faq.html`
- [ ] 🔥 **`budget/lib/widgets/util/appLinks.dart:388`** — commented-out `cashewapp.web.app` reference
- [ ] 🔥 **`budget/web/index.html:43-52`** — all 4 OG/Twitter meta tags point to `https://cashewapp.web.app/assets/preview.png`

---

## 7. Social/Web Meta

- [ ] 🔥 **`budget/web/index.html:43-52`** — og:url, og:image, twitter:url, twitter:image point to `cashewapp.web.app/assets/preview.png` — replace with your own hosted preview image

---

## 8. Translations (User-Facing Strings)

- [ ] 🔥 **`budget/assets/translations/generated/no.json:475`** — `"Takk for at du støtter cashew!"` → `"Ledger"`
- [ ] 🔥 **`budget/assets/translations/generated/sv.json:475`** — `"Tack för att du stöder cashew!"` → `"Ledger"`
- [ ] ⚡ **All translation files** — key `"enjoying-cashew-question"` — functional but the key name still says "cashew". Consider renaming.

---

## 9. Code Cleanup

- [ ] ⚡ **`budget/lib/pages/aboutPage.dart:46,546,591`** — variable name `cashewInformation` → consider renaming
- [ ] ⚡ **`budget/lib/pages/settingsPage.dart:185`** — comment `// openUrl("https://github.com/jameskokoska/Cashew");`
- [ ] ⚡ **`budget/lib/widgets/util/appLinks.dart:388`** — comment `// if (request.url.startsWith('https://cashewapp.web.app/'))`
- [ ] ⚡ **`budget/pubspec.yaml:1`** — `name: budget` — consider renaming to `ledger`

---

## 10. Documentation

- [ ] ✅ **`README.md`** — Cashew attribution preserved (intentional) ✓
- [ ] 📝 **`ROADMAP.md`** — update progress as items get checked off
- [ ] ℹ️ **`budget/lib/widgets/showChangelog.dart`** — contains historical "Cashew" changelog entries from upstream — these are intentional records

---

## 11. Splash Screen

- [ ] 📝 **Android `launch_background.xml`** — currently default Flutter splash, no Cashew branding (verified clean)
- [ ] 📝 **iOS `LaunchScreen.storyboard`** — currently default Flutter splash (verified clean)
- [ ] 📝 If you want a branded splash screen, create one with the Ledger logo + deep teal background

---

## Quick Summary by Severity

| Severity | Count | Action |
|----------|-------|--------|
| 🔥🔥 **Critical** | 12 | Must fix before any build/release |
| 🔥 **Major** |  venti | Should fix before public release |
| ⚡ **Minor** | 5 | Nice to have |
| ℹ️ **Info** | 5 | Requires decision (firebase, IAP, bundle ID) |

---

*Generated by automated repo scan. Last updated: 2026-05-20*

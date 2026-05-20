# Ledger

<div align="center">
  <img alt="Ledger Logo" src="budget/assets/icon/logo.png" width="150px">
</div>

---

## Overview

Ledger is a full-fledged, open-source personal finance tracker built with Flutter. It uses Drift SQL for local storage and Firebase for optional sync and backup. Ledger helps you manage budgets, track expenses, set financial goals, and gain insights into your spending — all with a beautiful Material You design.

Ledger is a fork of [Cashew](https://github.com/jameskokoska/Cashew) by jameskokoska. Development started in September 2021.

---

## Features

### 💰 Transaction Management
- Multiple transaction types: expense, income, upcoming, subscriptions, recurring, credit (lent), debt (borrowed)
- Custom categories with icons and colors
- Smart auto-categorization from transaction titles
- Search, filter, and bulk selection for transactions

### 📊 Budget Management
- Custom budgets with flexible time periods (weekly, monthly, yearly, custom)
- Per-category spending limits within budgets
- Past budget history and comparison
- Goals and long-term loan tracking

### 💱 Multi-Currency Support
- Live exchange rates via CDN
- Automatic currency conversion across accounts
- Configurable per-account currency settings

### 🔒 Security & Privacy
- Biometric lock (fingerprint, face)
- Google Sign-In for backup sync
- Local-first architecture — your data stays on your device

### 🎨 Material You Design
- Dynamic color theming (Material You on Android 12+)
- Custom accent colors
- Light and dark mode
- Customizable home screen widget dashboard

### ☁️ Backup & Sync
- Google Drive backup and restore
- Cross-device sync via Firebase
- CSV import/export
- Full database export

### 🤖 Smart Automation
- Email notification parsing for auto-transactions
- App links for pre-filled transaction creation
- Custom scanner templates

---

## Quick Start

### Android
Download the latest APK or App Bundle from the [Releases page](https://github.com/ningtoba/Ledger/releases).

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Dart) |
| Database | Drift SQL (SQLite) |
| State | Provider + shared_preferences |
| Auth | Firebase Auth + Google Sign-In |
| Sync | Cloud Firestore + Google Drive API |
| Payments | in_app_purchase (premium features) |
| Localization | easy_localization (40+ languages) |
| CI/CD | GitHub Actions |

---

## Building from Source

### Prerequisites
- Flutter SDK (3.x or later)
- Dart SDK (3.x or later)

### Android
```bash
cd budget
flutter pub get
flutter build appbundle --release
```

### iOS (requires macOS)
```bash
cd budget
flutter pub get
flutter build ipa
```

### Web (PWA)
```bash
cd budget
flutter pub get
flutter build web --release
```

### Firebase Deployment
```bash
firebase deploy
```

---

## Project Structure

```
Ledger/
├── budget/                    # Flutter app package
│   ├── lib/
│   │   ├── database/          # Drift schema, tables, migrations
│   │   │   └── tables/        # Domain module table definitions
│   │   ├── pages/             # Screen/page widgets
│   │   ├── struct/            # App state, settings, utilities
│   │   ├── utils/             # Focused utility helpers
│   │   ├── widgets/           # Reusable UI components
│   │   └── colors.dart        # Theme engine & palette
│   ├── assets/                # Fonts, icons, categories, translations
│   │   └── icon/              # App icon assets
│   ├── packages/              # Bundled packages
│   └── test/                  # Unit & widget tests
├── .github/                   # CI workflows, PR templates
├── promotional/               # Store assets, banners
├── ROADMAP.md                 # Project roadmap and milestones
└── scripts/                   # Build/deploy scripts
```

---

## Development

### Running Tests
```bash
cd budget
flutter test
```

### Code Analysis
```bash
cd budget
flutter analyze
```

### Translations
Translations are available as CSV-generated JSON files under `assets/translations/generated/`. To update:
```bash
python3 budget/assets/translations/generate-translations.py
```

The master translations spreadsheet is available [here](https://docs.google.com/spreadsheets/d/1QQqt28cmrby6JqxLm-oxUXCuM3alniLJ6IRhcPJDOtk/edit?usp=sharing). If you would like to help translate, please reach out via email: dapperappdeveloper@gmail.com.

---

## License

[GNU General Public License v3.0](LICENSE)

---

## Developer Notes

### Wallets vs. Accounts
`Wallets` have been renamed to `Accounts` on the front-end but internally, the name `Wallet` is still used.

### Objectives vs. Goals
`Objectives` have been renamed to `Goals` on the front-end but internally, the name `Objectives` is still used.

### Long Term Loans
Long term loans create a goal. However, the goals total is not used. Instead the total of the goal is calculated by totalling the proper polarity of transactions of the opposite type. For example, if it was a loan of $100 lent out, the initial transaction would be $100 of negative polarity (expense) and that would be the total of the goal. When a payment is made, it is made in the opposite (positive) polarity (income) and added to the total 'paid back'. We can easily find how much is remaining by taking the difference (or the addition including polarities).

### Bundled Packages
This repository contains, bundled in, modified versions of the discontinued packages listed below. They can be found in the folder `/budget/packages`:

- [implicitly_animated_reorderable_list](https://pub.dev/packages/implicitly_animated_reorderable_list)
- [sliding_sheet](https://pub.dev/packages/sliding_sheet)

### GitHub Release
1. Create a tag for the current version specified in `pubspec.yaml`
2. `git tag <version>`
3. Push the tag: `git push origin <version>`
4. Create the release and upload binaries at https://github.com/ningtoba/Ledger/releases/new

### Develop Wirelessly on Android
```bash
adb tcpip 5555
adb connect <IP>
```
Get the phone's IP by going to `About Phone` > `Status Information` > `IP Address`.

### Migrate Database
1. Make any database changes to the schema and tables
2. Bump the schema version — change `int schemaVersionGlobal = ...+1` in `tables.dart`
3. Change to the app directory: `cd budget/`
4. Generate database code: `dart run build_runner build`
5. Export the new schema:
   - Generate schema dump for the newly created schema
   - Replace `[schemaVersion]` with the value of `schemaVersionGlobal`
   - Run: `dart run drift_dev schema dump lib/database/tables.dart drift_schemas/drift_schema_v[schemaVersion].json`
6. Generate step-by-step migrations: `dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart`
7. Implement migration strategy in the `await stepByStep(...)` function in `tables.dart`

### Platform Detection
Use `getPlatform()` from `functions.dart` instead of `Platform` since `Platform` is not supported on web.

### Routing
Use `pushRoute(context, page)` from `functions.dart` for navigation — it handles platform routing and `PageRouteBuilder`.

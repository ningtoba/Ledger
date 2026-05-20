# Ledger Roadmap

> **Status:** Active Development
> **Current Phase:** Foundation Cleanup & Rebrand

---

## Milestone 1 — Foundation Cleanup 🏗️ (2-3 weeks)

**Status: In Progress** ✅

- [x] Refactor `tables.dart` (7667 lines) into domain modules
- [x] Refactor `functions.dart` (1489 lines) into focused utility files
- [x] Replace discontinued packages (sliding_sheet, implicitly_animated_reorderable_list)
- [x] Remove dead code and unused dependencies
- [x] Fix CI pipeline (GitHub Actions → Flutter workflow)
- [x] Add initial test suite (unit + widget tests)
- [x] Update analysis_options.yaml with lint rules
- [x] Add PR template and CONTRIBUTING guide

**Target:** v1.0.0-alpha

## Milestone 2 — Rebrand & Visual Identity 🎨 (2-3 weeks)

**Status: In Progress** ✅

- [x] Rename "Cashew" to "Ledger" across all files (code, assets, configs)
- [x] Update web manifest, index.html, pubspec.yaml
- [x] Fix broken favicon link
- [x] Update default accent color to deep teal (#0D4F4F)
- [x] Rewrite README with Ledger brand identity
- [x] Update color palette across the app
- [x] New app icon (replace cashew nut with ledger-themed icon)
- [ ] Update splash screen (Android launch_background.xml, iOS LaunchScreen.storyboard)
- [ ] Create store screenshots with new branding

**Target:** v1.0.0-beta

## Milestone 3 — Architecture & Developer Experience 🛠️ (3-4 weeks)

**Status:** Planned

- [ ] Refactor `addTransactionPage.dart` (5207 lines) into reusable form components
- [ ] Refactor `settingsPage.dart` (1821 lines) into section widgets
- [ ] Regenerate Drift code (run build_runner to fix tables.g.dart)
- [ ] Add SQLite encryption (sqlcipher)
- [ ] Database query optimization + indexes for frequently queried columns
- [ ] Lazy loading for transaction lists (paginated queries)
- [ ] Add Dart/Flutter format check to CI

**Target:** v1.0.0-rc

## Milestone 4 — Reliability & Performance ⚡ (3-4 weeks)

**Status:** Planned

- [ ] Offline-first architecture with IndexedDB fallback for web
- [ ] Service worker caching for PWA
- [ ] Incremental sync engine (replace full-database Google Drive uploads)
- [ ] CI/CD for Android appbundle releases
- [ ] CI/CD for iOS IPA releases
- [ ] Code coverage to 50%+

**Target:** v1.0.0 stable

## Milestone 5 — Smart Features 🤖 (4-6 weeks)

**Status:** Planned

- [ ] AI-powered transaction categorization (auto-detect category from name)
- [ ] Recurring transaction auto-detection (suggest subscription/repetitive)
- [ ] Spending forecast and budget alerts
- [ ] Receipt OCR scanning (auto-fill from images)
- [ ] Bank statement import (CSV, OFX, QFX)
- [ ] Advanced reporting (PDF export, custom date range comparisons)

**Target:** v1.1.0

## Milestone 6 — Advanced Financial Management 📈 (6-8 weeks)

**Status:** Planned

- [ ] Multi-user household budgets (real-time shared budgets)
- [ ] Investment/portfolio tracking
- [ ] Savings rules and round-up automation
- [ ] Desktop builds (macOS, Windows, Linux)
- [ ] End-to-end tests
- [ ] Code coverage 75%+

**Target:** v1.2.0

## Milestone 7 — Ecosystem & Scale 🌐 (ongoing)

**Status:** Planned

- [ ] Public API for third-party integrations
- [ ] Plugin system for custom importers/exporters
- [ ] Community translation platform (replace manual CSV process)
- [ ] Performance benchmarking and regression suite
- [ ] Accessibility audit (screen reader, contrast, navigation)
- [ ] Internationalization RTL support
- [ ] Security audit
- [ ] Privacy policy page

---

This roadmap is a living document. Milestones and priorities may shift based on development progress.

---

*Last updated: 2026-05-20*

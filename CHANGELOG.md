# Changelog

## 2.0.0

### Breaking Changes

- **Renamed `monitor()` → `isEnabled()`** — read-only status check, no longer opens Settings
- **Renamed `set()` → `setEnabled()`** — clearer intent
- **Renamed event `monitor` → `dndStateChanged`** — now properly typed in TypeScript
- **Added `addListener`/`removeAllListeners`** to TypeScript interface

### Bug Fixes

- **Android:** Fixed crash on Android 14+ — added `RECEIVER_NOT_EXPORTED` flag to `registerReceiver`
- **Android:** `isEnabled()` no longer opens Settings as a side effect (was in `monitor()`)
- **Android:** `setEnabled()` now throws `SecurityException` instead of silently failing when permission not granted
- **Android:** Added proper error handling with `call.reject()`
- **iOS:** Replaced stub implementation with heuristic DND detection via `UNUserNotificationCenter`
- **iOS:** Migrated from `.m` bridge file to `CAPBridgedPlugin` protocol
- **iOS:** Fixed test file (replaced boilerplate `echo()` with real tests)

### Improvements

- Upgraded to TypeScript 6, AGP 8.13.0, Gradle 8.14.3, SDK 36, Java 21
- Replaced `tsc --emitDeclarationOnly` with `vite-plugin-dts`
- Added `type: "module"` to package.json
- Added JSDoc comments to TypeScript interface
- Added tests: 3 web (Vitest), 2 Android (JUnit), 3 iOS (XCTest)
- Added GitHub Actions CI (web + Android + iOS) and publish workflow

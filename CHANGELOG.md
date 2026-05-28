# Changelog

## Unreleased

## 2.1.1 (2026-05-28)

### Bug Fixes

- **Packaging:** Node ESM consumers failed to import the package with `SyntaxError: exports is not defined in ES module scope`. Same bug as `@gachlab/capacitor-permissions` (fixed in 3.1.2, gachlab/capacitor-permissions-plugin#10): the CJS bundle was emitted as `dist/plugin.cjs.js` (`.js` extension) while `package.json` declares `"type": "module"`, so Node parsed it as ESM and rejected its CommonJS syntax. Renamed the CJS output to `dist/plugin.cjs`, pointed `"main"` at it, and added an `"exports"` field with conditional `import`/`require`. Closes #10.

### CI

- Moved the iOS job from `macos-15` (GitHub-hosted) to the same self-hosted Mac Mini that runs Android e2e. Eliminates the recurring Swift Package Manager cache-stale flake (`Cordova.xcframework.zip already exists in file system`) — the SPM cache stays hot between runs on a persistent runner. Expected iOS wall-time drop similar to permissions plugin: ~7m41s → ~2m12s.
- iOS e2e script (`e2e-ios-dnd.sh`) now defaults to a substring match (`"iPhone"`) instead of hard-coding `"iPhone 16"`, so the simulator selector picks whatever model is installed on the runner. Override with `SIMULATOR_NAME=…` to pin a specific model.

### Build

- Bumped Android Gradle Plugin `8.13.0` → `9.2.1` and Gradle wrapper `8.14.3` → `9.5.1` so the plugin's own CI builds against the same AGP major (9.x) that consumer apps use. No consumer-facing change — consuming apps apply their own root AGP at build time. Closes #1.
- Refreshed `@capacitor/*` toolchain in the lockfile to `8.3.4` (was `8.0.1`). The bundled `@capacitor/android@8.0.1` build script still referenced `proguard-android.txt`, which AGP 9 rejects when compiling the `:capacitor-android` module. Lockfile only — `^8.0.1` spec unchanged.

## 2.0.1 (2026-05-21)

### Bug Fixes

- **Build:** Fixed empty `dist/esm/index.d.ts` — `vite-plugin-dts` with `rollupTypes: true` produced an empty types bundle under TypeScript 6 (its internal API Extractor uses TS 5.x and silently dropped all declarations). Removed `rollupTypes` and set `tsconfig.json` `rootDir: "src"` so per-file `.d.ts` files land flat at `dist/esm/` and consumers actually get types instead of `any`.

### Improvements

- **iOS:** Replaced 2-second polling timer with `UIApplication.didBecomeActiveNotification` / `willEnterForegroundNotification` observers. No more background battery drain; state is re-evaluated when the app returns to the foreground. Documented the trade-off in README (iOS has no system-level DND change event, so background toggles are not observed in real time).
- iOS Swift version aligned: `GachlabCapacitorDndPlugin.podspec` now declares `swift_version = '5.9'` to match `Package.swift`'s `swift-tools-version: 5.9` (was `5.1`).
- iOS dependency pinned: `Package.swift` now uses `.upToNextMajor(from: "8.0.0")` for `capacitor-swift-pm` instead of `branch: "main"`.
- Added `publishConfig.access: public` to `package.json`.

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

# Testing — @gachlab/capacitor-dnd-plugin

This plugin follows the gachlab **test pyramid: unit + integration + e2e on the 3
platforms**. The e2e layer reuses the harness pattern proven in
`capacitor-background-geolocation` (example host app + emulator/simulator driven
by scripts — **no Appium**). CI runs all layers in `.github/workflows/build.yml`.

## Layers

| Layer | Web | Android | iOS |
|---|---|---|---|
| **Unit** (mocked/shadowed) | vitest (`src/__tests__`) | Robolectric (`android/src/test`) | XCTest (`ios/PluginTests`) |
| **Integration** (real OS, no mocks) | — | instrumented (`android/src/androidTest`, emulator) | XCTest on simulator |
| **E2E** (round-trip to JS) | — | `example-app` + `adb` + logcat (`scripts/e2e-dnd.sh`) | `example-app` XCUITest (`scripts/e2e-ios-dnd.sh`) |

## Run locally

```bash
# Web unit
npm test

# Android unit (Robolectric — needs ANDROID_HOME)
cd android && ./gradlew test

# Android integration (needs a connected emulator/device)
cd android && ./gradlew connectedDebugAndroidTest

# Android e2e (needs an emulator + the example APK built)
npm run build
(cd example-app && npm install && npx cap sync android && cd android && ./gradlew assembleDebug)
./.github/scripts/e2e-dnd.sh

# iOS unit (macOS)
xcodebuild test -scheme GachlabCapacitorDndPlugin -destination 'platform=iOS Simulator,name=iPhone 16'

# iOS e2e (macOS)
npm run build && (cd example-app && npm install && npx cap sync ios)
./.github/scripts/e2e-ios-dnd.sh
```

## How the e2e harness works

`example-app/www/main.js` registers the plugin listeners and logs each event as
`[DND-E2E] event:dndStateChanged {...}`. Capacitor forwards this to logcat
(Android) / the WebView (iOS). The Android script toggles system DND with
`adb shell cmd notification set_dnd` and greps logcat for the tagged event; the
iOS XCUITest verifies the `isEnabled()` bridge round-trip.

## Manual checklist (not automatable)

- **iOS `dndStateChanged`**: iOS exposes no API to toggle Focus/DND from a test.
  Verify by hand: open the example app, toggle Focus in Control Center, confirm a
  `dndStateChanged` line appears in the on-screen log.
- **Android `setEnabled()`**: requires the user to grant *Do Not Disturb access*
  in system settings (`ACCESS_NOTIFICATION_POLICY`); verify the toggle once granted.

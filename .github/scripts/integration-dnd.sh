#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 gachlab
#
# Integration tests on a real emulator. Runs the plugin's instrumented
# androidTest suite (DoNotDisturb against the real NotificationManager) via
# `adb` + `am instrument` rather than Gradle's UTP runner — UTP's split-APK
# installer is flaky on CI emulators ("Broken pipe"), whereas plain adb is the
# proven path (same as the e2e harness).
#
# Pre-condition: the instrumented test APK is built on the host beforehand with
#   (cd android && ./gradlew assembleDebugAndroidTest)

set -euo pipefail

TEST_APK=$(find android/build/outputs/apk/androidTest/debug -name "*.apk" | head -1)
RUNNER="com.gachlab.capacitor.dnd.test/androidx.test.runner.AndroidJUnitRunner"

echo "→ Waiting for emulator to finish booting"
adb wait-for-device
timeout 180 bash -c 'while [[ "$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d "\r")" != "1" ]]; do sleep 2; done'
adb shell input keyevent 82 >/dev/null 2>&1 || true

echo "→ Installing instrumented test APK: $TEST_APK"
adb install -r -t "$TEST_APK"

echo "→ Running instrumented tests ($RUNNER)"
OUT=$(adb shell am instrument -w "$RUNNER" 2>&1)
echo "$OUT"

echo ""
echo "── Assertions ──────────────────────────────────────────────────────"
if echo "$OUT" | grep -qE "Process crashed|INSTRUMENTATION_FAILED|FAILURES!!!"; then
  echo "✗ Android integration tests FAILED"
  exit 1
fi
if echo "$OUT" | grep -qE "^OK \([0-9]+ test"; then
  echo "✓ Android integration tests PASSED"
  exit 0
fi
echo "✗ Could not confirm integration test success (no 'OK (N tests)' marker)"
exit 1

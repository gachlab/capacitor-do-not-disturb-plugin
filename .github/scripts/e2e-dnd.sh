#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 gachlab
#
# E2E: dndStateChanged round-trip for @gachlab/capacitor-dnd-plugin.
#
# Pre-conditions (satisfied by android-emulator-runner@v2):
#   • An Android emulator is booted and adb-connected.
#   • The debug APK is built at example-app/android/app/build/outputs/apk/debug/*.apk
#
# Mechanism:
#   The host app (example-app) registers a `dndStateChanged` listener and logs
#   each event to the WebView console as `[DND-E2E] event:dndStateChanged {...}`,
#   which Capacitor forwards to logcat. We toggle the system DND state with
#   `adb shell cmd notification set_dnd`, which fires the plugin's
#   ACTION_INTERRUPTION_FILTER_CHANGED receiver → JS event → logcat. We then
#   grep logcat to assert both an enabled:true and an enabled:false event fired.

set -euo pipefail

APK=$(find example-app/android/app/build/outputs/apk/debug -name "*.apk" | head -1)
PACKAGE="com.gachlab.capacitor.dnd.example"
ACTIVITY=".MainActivity"
LOGCAT_OUT="/tmp/e2e-logcat.txt"
PASS=0

"$(dirname "$0")/wait-for-emulator.sh"

echo "→ Installing APK: $APK"
adb install -r --no-streaming "$APK"

echo "→ Launching app"
adb shell am start -n "${PACKAGE}/${ACTIVITY}"

# Wait until the WebView has actually registered the JS listener before we
# toggle DND — otherwise the broadcast fires while "No listeners found" and the
# event never reaches JS. The Capacitor bridge logs the addListener call.
echo "→ Waiting for the WebView to register the dndStateChanged listener"
LISTENER_END=$(( $(date +%s) + 90 ))
until adb logcat -d 2>/dev/null | grep -q "addListener.*dndStateChanged"; do
  if [[ $(date +%s) -ge $LISTENER_END ]]; then
    echo "✗ JS never registered the dndStateChanged listener within 90 s"
    adb logcat -d | grep -iE "Capacitor|chromium|console|error" | tail -30
    exit 1
  fi
  sleep 2
done

# Normalise DND to OFF so the first real toggle below produces a state change.
echo "→ Normalising DND to off"
adb shell cmd notification set_dnd off || true
sleep 2

# Only capture events from the toggles below.
adb logcat -c

echo "→ Turning DND on (priority)"
adb shell cmd notification set_dnd priority
sleep 3

echo "→ Turning DND off"
adb shell cmd notification set_dnd off
sleep 3

adb logcat -d > "$LOGCAT_OUT" 2>&1 || true

echo ""
echo "── Assertions ──────────────────────────────────────────────────────"

if grep -qE '\[DND-E2E\] event:dndStateChanged.*"enabled":true' "$LOGCAT_OUT"; then
  echo "✓ dndStateChanged fired with enabled:true (DND turned on)"
  PASS=$((PASS + 1))
else
  echo "✗ no dndStateChanged enabled:true event in logcat"
fi

if grep -qE '\[DND-E2E\] event:dndStateChanged.*"enabled":false' "$LOGCAT_OUT"; then
  echo "✓ dndStateChanged fired with enabled:false (DND turned off)"
  PASS=$((PASS + 1))
else
  echo "✗ no dndStateChanged enabled:false event in logcat"
fi

# Every emitted event must carry a numeric timestamp (Fase 1 contract).
if grep -qE '\[DND-E2E\] event:dndStateChanged.*"timestamp":[0-9]{10,}' "$LOGCAT_OUT"; then
  echo "✓ event payload carries an epoch-ms timestamp"
  PASS=$((PASS + 1))
else
  echo "✗ event payload missing a numeric timestamp"
fi

echo ""
if [[ "$PASS" -eq 3 ]]; then
  echo "✓ DND E2E PASSED ($PASS/3)"
else
  echo "✗ DND E2E FAILED ($PASS/3)"
  echo "--- DND-E2E / dndStateChanged log lines ---"
  grep -iE "DND-E2E|dndStateChanged" "$LOGCAT_OUT" | tail -30 || echo "(none — event never reached JS)"
  echo "--- Capacitor / Console errors ---"
  grep -iE "Capacitor|chromium|AndroidRuntime|FATAL" "$LOGCAT_OUT" | tail -20 || echo "(none)"
  exit 1
fi

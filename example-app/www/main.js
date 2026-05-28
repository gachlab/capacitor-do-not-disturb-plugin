// SPDX-License-Identifier: MIT
// Copyright (c) 2026 gachlab
//
// Minimal host page exercising the DND plugin's public API on web/Android/iOS.
// The Capacitor native-bridge is injected before this script, so
// window.Capacitor.Plugins.DoNotDisturb is available without any npm imports.
//
// The e2e harness asserts by grepping logcat (Android) / reading the WebView
// (iOS) for the tagged lines emitted below.

/* global Capacitor */

document.addEventListener('DOMContentLoaded', () => {
  const DoNotDisturb = Capacitor.Plugins.DoNotDisturb;

  const out = document.getElementById('log');
  const stateEl = document.querySelector('[data-testid="dnd-state"]');
  const lastEvEl = document.querySelector('[data-testid="last-event"]');

  const log = (label, data) => {
    const line =
      `[${new Date().toISOString().slice(11, 19)}] ${label}` +
      (data === undefined ? '' : ' ' + JSON.stringify(data));
    out.textContent = line + '\n' + out.textContent;
    lastEvEl.textContent = label;
  };

  async function safe(label, fn) {
    try {
      const r = await fn();
      log(label, r);
      return r;
    } catch (e) {
      log(label + ' ERROR', { message: e?.message ?? String(e) });
    }
  }

  document.getElementById('check').onclick = () =>
    safe('isEnabled', async () => {
      const r = await DoNotDisturb.isEnabled();
      stateEl.textContent = r.enabled ? 'on' : 'off';
      return r;
    });
  document.getElementById('enable').onclick = () =>
    safe('setEnabled(true)', () => DoNotDisturb.setEnabled({ enabled: true }));
  document.getElementById('disable').onclick = () =>
    safe('setEnabled(false)', () => DoNotDisturb.setEnabled({ enabled: false }));

  DoNotDisturb.addListener('dndStateChanged', (state) => {
    stateEl.textContent = state.enabled ? 'on' : 'off';
    // Tagged line the e2e script greps for in logcat.
    console.log('[DND-E2E] event:dndStateChanged ' + JSON.stringify(state));
    log('event:dndStateChanged', state);
  });

  log('ready');
});

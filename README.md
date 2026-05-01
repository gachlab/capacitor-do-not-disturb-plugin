# @gachlab/capacitor-dnd-plugin

A Capacitor plugin to detect and control Do Not Disturb (DND) mode.

| Platform | Detection | Control |
|----------|-----------|---------|
| Android  | ✅ `NotificationManager.getCurrentInterruptionFilter()` | ✅ Requires `ACCESS_NOTIFICATION_POLICY` |
| iOS      | ⚠️ Heuristic via notification settings | ❌ Not allowed by iOS |
| Web      | ❌ Always returns `false` | ❌ Not supported |

## Installation

```bash
npm install @gachlab/capacitor-dnd-plugin
npx cap sync
```

## Usage

```typescript
import { DoNotDisturb } from '@gachlab/capacitor-dnd-plugin';

// Check if DND is enabled
const { enabled } = await DoNotDisturb.isEnabled();
console.log('DND is', enabled ? 'on' : 'off');

// Listen for DND state changes
await DoNotDisturb.addListener('dndStateChanged', (state) => {
  console.log('DND changed:', state.enabled);
});

// Enable DND (Android only)
await DoNotDisturb.setEnabled({ enabled: true });

// Disable DND (Android only)
await DoNotDisturb.setEnabled({ enabled: false });
```

## API

### isEnabled()

```typescript
isEnabled() => Promise<{ enabled: boolean }>
```

Returns the current Do Not Disturb state.

---

### setEnabled(options)

```typescript
setEnabled(options: { enabled: boolean }) => Promise<void>
```

Enables or disables Do Not Disturb mode. Only supported on Android. Requires `ACCESS_NOTIFICATION_POLICY` permission — the user must grant this manually in system settings.

Rejects with an error on iOS and Web.

---

### addListener('dndStateChanged', ...)

```typescript
addListener(
  eventName: 'dndStateChanged',
  listenerFunc: (state: { enabled: boolean }) => void,
) => Promise<PluginListenerHandle>
```

Listens for changes to the DND state. On Android, this uses a `BroadcastReceiver`. On iOS, this polls notification settings every 2 seconds.

---

### removeAllListeners()

```typescript
removeAllListeners() => Promise<void>
```

Removes all event listeners for this plugin.

## Platform Notes

### Android

Requires `ACCESS_NOTIFICATION_POLICY` permission. The user must manually enable "Do Not Disturb access" for your app in system settings. The `setEnabled()` method will reject if this permission is not granted.

### iOS

Apple does not provide a public API to read or control Focus/DND state. This plugin uses a heuristic: if notifications are authorized but alerts are disabled, DND is likely active. This is not 100% reliable. `setEnabled()` always rejects on iOS.

## Migration from v1

v2 introduces breaking changes to the API:

```diff
- const { enabled } = await DoNotDisturb.monitor();
+ const { enabled } = await DoNotDisturb.isEnabled();

- await DoNotDisturb.set({ enabled: true });
+ await DoNotDisturb.setEnabled({ enabled: true });

- DoNotDisturb.addListener('monitor', callback);
+ DoNotDisturb.addListener('dndStateChanged', callback);
```

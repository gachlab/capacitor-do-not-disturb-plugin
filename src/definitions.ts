import type { PluginListenerHandle } from '@capacitor/core';

export interface DoNotDisturbPlugin {
  /**
   * Returns the current Do Not Disturb state.
   */
  isEnabled(): Promise<{ enabled: boolean }>;

  /**
   * Enables or disables Do Not Disturb mode.
   * On Android, requires `ACCESS_NOTIFICATION_POLICY` permission.
   * On iOS and Web, this will reject with an error.
   */
  setEnabled(options: { enabled: boolean }): Promise<void>;

  /**
   * Listens for changes to the Do Not Disturb state.
   *
   * `timestamp` is the epoch time in milliseconds when the change was observed,
   * so consumers can keep an accurate audit log.
   */
  addListener(
    eventName: 'dndStateChanged',
    listenerFunc: (state: { enabled: boolean; timestamp: number }) => void,
  ): Promise<PluginListenerHandle>;

  /**
   * Removes all listeners for this plugin.
   */
  removeAllListeners(): Promise<void>;
}

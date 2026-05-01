import { WebPlugin } from '@capacitor/core';

import type { DoNotDisturbPlugin } from './definitions';

export class DoNotDisturbWeb extends WebPlugin implements DoNotDisturbPlugin {
  async isEnabled(): Promise<{ enabled: boolean }> {
    return { enabled: false };
  }

  async setEnabled(): Promise<void> {
    throw new Error('Setting DND state is not supported on web');
  }
}

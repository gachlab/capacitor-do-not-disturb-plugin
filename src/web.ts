import { WebPlugin } from '@capacitor/core';

import type { DoNotDisturbPlugin } from './definitions';

export class DoNotDisturbWeb extends WebPlugin implements DoNotDisturbPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}

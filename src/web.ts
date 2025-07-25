import { WebPlugin } from "@capacitor/core";

import type { DoNotDisturbPlugin } from "./definitions";

export class DoNotDisturbWeb extends WebPlugin implements DoNotDisturbPlugin {
  async monitor(): Promise<{ enabled: boolean }> {
    return { enabled: false };
  }

  async set(_options: { enabled: boolean }): Promise<void> {
    throw new Error('Setting DND state not supported on web');
  }


}

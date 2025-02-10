import { WebPlugin } from "@capacitor/core";

import type { DoNotDisturbPlugin } from "./definitions";

export class DoNotDisturbWeb extends WebPlugin implements DoNotDisturbPlugin {
  monitor(): Promise<any> {
    throw new Error("Method not implemented in web.");
  }
}

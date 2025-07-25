export interface DoNotDisturbPlugin {
  monitor(): Promise<{ enabled: boolean }>;
  set(options: { enabled: boolean }): Promise<void>;
}

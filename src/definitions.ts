export interface DoNotDisturbPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}

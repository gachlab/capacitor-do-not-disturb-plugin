import { describe, it, expect, beforeEach } from 'vitest';
import { DoNotDisturbWeb } from '../web';

describe('DoNotDisturbWeb', () => {
  let plugin: DoNotDisturbWeb;

  beforeEach(() => {
    plugin = new DoNotDisturbWeb();
  });

  it('isEnabled returns false on web', async () => {
    const result = await plugin.isEnabled();
    expect(result).toEqual({ enabled: false });
  });

  it('setEnabled throws on web', async () => {
    await expect(plugin.setEnabled({ enabled: true })).rejects.toThrow(
      'Setting DND state is not supported on web',
    );
  });

  it('setEnabled throws for disable too', async () => {
    await expect(plugin.setEnabled({ enabled: false })).rejects.toThrow();
  });
});

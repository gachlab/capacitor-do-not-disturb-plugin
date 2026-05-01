import { describe, it, expect, beforeEach } from 'vitest';
import { DoNotDisturbWeb } from '../web';

describe('DoNotDisturbWeb', () => {
  let plugin: DoNotDisturbWeb;

  beforeEach(() => {
    plugin = new DoNotDisturbWeb();
  });

  describe('isEnabled', () => {
    it('returns false on web (DND not detectable)', async () => {
      const result = await plugin.isEnabled();
      expect(result).toEqual({ enabled: false });
    });

    it('returns an object with enabled property', async () => {
      const result = await plugin.isEnabled();
      expect(result).toHaveProperty('enabled');
      expect(typeof result.enabled).toBe('boolean');
    });
  });

  describe('setEnabled', () => {
    it('throws when trying to enable DND', async () => {
      await expect(plugin.setEnabled({ enabled: true })).rejects.toThrow(
        'Setting DND state is not supported on web',
      );
    });

    it('throws when trying to disable DND', async () => {
      await expect(plugin.setEnabled({ enabled: false })).rejects.toThrow(
        'Setting DND state is not supported on web',
      );
    });
  });
});

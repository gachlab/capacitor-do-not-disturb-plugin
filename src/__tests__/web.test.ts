import { describe, it, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { DoNotDisturbWeb } from '../web';

describe('DoNotDisturbWeb', () => {
  let plugin: DoNotDisturbWeb;

  beforeEach(() => {
    plugin = new DoNotDisturbWeb();
  });

  describe('isEnabled', () => {
    it('returns false on web (DND not detectable)', async () => {
      const result = await plugin.isEnabled();
      assert.deepStrictEqual(result, { enabled: false });
    });

    it('returns an object with enabled property', async () => {
      const result = await plugin.isEnabled();
      assert.ok('enabled' in Object(result));
      assert.strictEqual(typeof result.enabled, 'boolean');
    });
  });

  describe('setEnabled', () => {
    it('throws when trying to enable DND', async () => {
      await assert.rejects(() => plugin.setEnabled({ enabled: true }), /Setting DND state is not supported on web/);
    });

    it('throws when trying to disable DND', async () => {
      await assert.rejects(() => plugin.setEnabled({ enabled: false }), /Setting DND state is not supported on web/);
    });
  });
});

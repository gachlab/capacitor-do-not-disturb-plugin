import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  build: {
    lib: {
      entry: resolve(__dirname, 'src/index.ts'),
      name: 'capacitorDoNotDisturb',
      formats: ['es', 'cjs', 'iife'],
      fileName: (format) => {
        switch (format) {
          case 'es':
            return 'esm/index.js';
          case 'cjs':
            return 'plugin.cjs.js';
          case 'iife':
            return 'plugin.js';
          default:
            return `plugin.${format}.js`;
        }
      },
    },
    rollupOptions: {
      external: ['@capacitor/core'],
      output: {
        globals: {
          '@capacitor/core': 'capacitorExports',
        },
      },
    },
    outDir: 'dist',
    sourcemap: true,
  },
});
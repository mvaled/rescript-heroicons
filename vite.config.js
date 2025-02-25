import { defineConfig } from 'vite'
import rescript from '@jihchi/vite-plugin-rescript';

export default defineConfig({
  plugins: [rescript(),],
  base: "",
  build: ['es2020'],
  // Prevent ReScript messages from being lost when we run all things at the
  // same time.
  clearScreen: false,
});

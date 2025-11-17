import { defineConfig } from 'vite'
import rescript from '@jihchi/vite-plugin-rescript';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [
    tailwindcss(),
    rescript(),
  ],
  base: "",
  build: {
    target: 'es2020',
  },
  // Prevent ReScript messages from being lost when we run all things at the
  // same time.
  clearScreen: false,
});

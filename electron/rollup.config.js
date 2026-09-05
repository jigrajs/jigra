import nodeResolve from 'rollup-plugin-node-resolve';

export default {
  input: 'dist/esm/index.js',
  output: {
    file: 'dist/electron-bridge.js',
    format: 'iife',
    name: 'jigraExports'
  },
  sourcemap: true,
  banner: '/*! Jigra: https://jigrajs.web.app/ - MIT License */',
  plugins: [
    nodeResolve()
  ]
};

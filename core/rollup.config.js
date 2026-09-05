import nodeResolve from 'rollup-plugin-node-resolve';

const banner = '/*! Jigra: https://jigrajs.web.app/ - MIT License */';

export default {
  input: 'dist/esm/index.js',
  output: [
    {
      file: 'dist/jigra.js',
      format: 'iife',
      name: 'jigraExports',
      banner,
      sourcemap: true
    },
    {
      file: 'dist/index.js',
      format: 'cjs',
      banner,
      sourcemap: true
    }
  ],
  plugins: [
    nodeResolve()
  ]
};

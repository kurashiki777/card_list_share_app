module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    require('tailwindcss'), // ここにTailwind CSSを追加
    require('autoprefixer') // ここにAutoprefixerを追加
  ]
}

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
  theme: {
    extend: {
      backgroundColor: {
        'body': '#ffffff'
      },
      fontSize: {
        vw: '3vw', // ビューポートの幅の3%に基づくフォントサイズ
      },
      maxWidth: {
        'max-name': '24px', // フォントサイズの最大値を24pxに設定
      }
    },
  },
}

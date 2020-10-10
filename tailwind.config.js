module.exports = {
  future: {
    purgeLayersByDefault: true,
  },
  purge: {
    content: ['./src/pages/**/*.html.ecr',
    './src/pages/**/*.cr',
    './src/components/**/*.cr',
    './src/js/**/*.js']
  },
  theme: {
    extend: {
      colors: {
        'kind-gray': '#E6EBF1',
        'kind-blue': '#3182ce',
        'kind-light-blue': '#c1d9f0',
        'kind-black': '#30475e'
      },
      minHeight: {
        '10': '10rem'
      },
      width: {
        '100': '26rem'
      }
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/ui')({
      layout: 'sidebar',
    }),
  ],
}

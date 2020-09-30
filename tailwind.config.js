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
        'kind-blue': '#3182ce'
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

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
    extend: {},
  },
  variants: {},
  plugins: [
    require('@tailwindcss/ui')({
      layout: 'sidebar',
    }),
  ],
}

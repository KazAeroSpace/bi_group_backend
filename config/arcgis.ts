export default ({ env }) => ({
  url: env('ARCGIS_SERVER_URL', ''),
  auth: {
    username: env('ARCGIS_AUTH_USERNAME', ''),
    password: env('ARCGIS_AUTH_PASSWORD', ''),
  }
})

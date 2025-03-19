const path = require('path');

module.exports = {
  apps: [
    {
      name: 'sistema-pedidos-backend',
      cwd: path.join(__dirname, 'backend'),
      script: 'src/server.js',
      env: {
        NODE_ENV: 'production',
        PORT: 8081,
        HOST: '0.0.0.0'
      }
    },
    {
      name: 'sistema-pedidos-frontend',
      script: 'serve',
      env: {
        PM2_SERVE_PATH: path.join(__dirname, 'dist'),
        PM2_SERVE_PORT: 5173,
        PM2_SERVE_SPA: 'true',
        PM2_SERVE_HOMEPAGE: '/index.html'
      }
    }
  ]
} 
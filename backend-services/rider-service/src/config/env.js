// Environment configuration
module.exports = {
  JWT_SECRET: process.env.JWT_SECRET || 'uber_clone_default_secret_key',
  DB_HOST: process.env.DB_HOST || 'localhost',
  DB_PORT: process.env.DB_PORT || 5432,
  DB_NAME: process.env.DB_NAME || 'uber_clone',
  DB_USER: process.env.DB_USER || 'postgres',
  DB_PASSWORD: process.env.DB_PASSWORD || 'password'
};
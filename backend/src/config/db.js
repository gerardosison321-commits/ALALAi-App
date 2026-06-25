const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host             : process.env.DB_HOST     || 'localhost',
  port             : Number(process.env.DB_PORT) || 3306,
  user             : process.env.DB_USER     || 'root',
  password         : process.env.DB_PASSWORD || 'root',
  database         : process.env.DB_NAME     || 'alalayai',
  waitForConnections: true,
  connectionLimit  : 10,
  timezone         : '+08:00',  // Philippine Standard Time
});

// Test connection on startup
pool.getConnection()
  .then(conn => { console.log('🗄️  MySQL connected'); conn.release(); })
  .catch(err  => console.error('❌  MySQL connection failed:', err.message));

module.exports = pool;
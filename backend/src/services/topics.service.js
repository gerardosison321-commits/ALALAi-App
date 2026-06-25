const db = require('../config/db');

// Get all subjects + grade levels available
async function getAll() {
  const [rows] = await db.query(
    `SELECT id, subject, grade_level, title, description, language
     FROM topics
     WHERE is_active = TRUE
     ORDER BY subject, grade_level, title`
  );
  return rows;
}

// Filter by subject and/or grade level
async function getFiltered({ subject, gradeLevel }) {
  let sql    = 'SELECT id, subject, grade_level, title, description, language FROM topics WHERE is_active = TRUE';
  const args = [];

  if (subject) {
    sql += ' AND subject = ?';
    args.push(subject);
  }
  if (gradeLevel) {
    sql += ' AND grade_level = ?';
    args.push(Number(gradeLevel));
  }

  sql += ' ORDER BY title';
  const [rows] = await db.query(sql, args);
  return rows;
}

// Get a single topic WITH full content (for Laya to use)
async function getById(id) {
  const [rows] = await db.query(
    'SELECT * FROM topics WHERE id = ? AND is_active = TRUE',
    [id]
  );
  return rows[0] || null;
}

module.exports = { getAll, getFiltered, getById };
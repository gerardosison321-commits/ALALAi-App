const pool = require('../config/db');
const { v4: uuidv4 } = require('uuid');

// POST /api/auth/register
async function register(req, res, next) {
  try {
    const { name, email, password, gradeLevel } = req.body;

    // Check if email exists
    const [existing] = await pool.execute(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );
    if (existing.length > 0) {
      return res.status(409).json({ success: false, error: 'Email already registered' });
    }

    const id = uuidv4();
    await pool.execute(
      `INSERT INTO users (id, name, email, password, grade_level) VALUES (?, ?, ?, ?, ?)`,
      [id, name, email, password, gradeLevel]
    );

    res.status(201).json({ success: true, data: { userId: id, name, email, gradeLevel } });
  } catch (err) { next(err); }
}

// POST /api/auth/login
async function login(req, res, next) {
  try {
    const { email, password } = req.body;

    const [users] = await pool.execute(
      'SELECT * FROM users WHERE email = ? AND password = ?',
      [email, password]
    );

    if (users.length === 0) {
      return res.status(401).json({ success: false, error: 'Invalid email or password' });
    }

    const user = users[0];
    res.json({
      success: true,
      data: {
        userId: user.id,
        name: user.name,
        email: user.email,
        gradeLevel: user.grade_level,
        language: user.language,
      }
    });
  } catch (err) { next(err); }
}

// GET /api/auth/me
async function getMe(req, res, next) {
  try {
    const { userId } = req.query;
    if (!userId) {
      return res.status(400).json({ success: false, error: 'userId required' });
    }

    const [users] = await pool.execute(
      'SELECT id, name, email, grade_level, language FROM users WHERE id = ?',
      [userId]
    );

    if (users.length === 0) {
      return res.status(404).json({ success: false, error: 'User not found' });
    }

    const user = users[0];

    // Get stats
    const [xpResult] = await pool.execute(
      `SELECT COALESCE(SUM(cards_correct * 10), 0) as total_xp 
       FROM sessions WHERE user_id = ? AND status = 'completed'`,
      [userId]
    );

    const [streakResult] = await pool.execute(
      `SELECT COUNT(DISTINCT DATE(completed_at)) as streak_days 
       FROM sessions WHERE user_id = ? AND status = 'completed' 
       AND completed_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)`,
      [userId]
    );

    const [subjectsResult] = await pool.execute(
      `SELECT COUNT(DISTINCT subject) as completed_subjects 
       FROM sessions WHERE user_id = ? AND status = 'completed'`,
      [userId]
    );

    res.json({
      success: true,
      data: {
        ...user,
        xp: xpResult[0].total_xp,
        streak: streakResult[0].streak_days,
        subjectsCompleted: subjectsResult[0].completed_subjects,
      }
    });
  } catch (err) { next(err); }
}

module.exports = { register, login, getMe };
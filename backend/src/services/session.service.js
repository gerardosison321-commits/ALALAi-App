const { v4: uuidv4 } = require('uuid');
const db = require('../config/db');

// Create a new study session
async function create({ topicId, gradeLevel, subject, language }) {
  const id = uuidv4();
  await db.query(
    `INSERT INTO sessions (id, topic_id, grade_level, subject, language)
     VALUES (?, ?, ?, ?, ?)`,
    [id, topicId || null, gradeLevel, subject, language || 'mixed']
  );
  return getById(id);
}

// Fetch session by ID
async function getById(id) {
  const [rows] = await db.query('SELECT * FROM sessions WHERE id = ?', [id]);
  return rows[0] || null;
}

// Save a card result (correct / wrong / skipped)
async function recordCardResult(sessionId, cardId, result) {
  await db.query(
    'UPDATE cards SET result = ? WHERE id = ? AND session_id = ?',
    [result, cardId, sessionId]
  );

  // Update session counters
  const col = result === 'correct' ? 'cards_correct'
            : result === 'wrong'   ? 'cards_wrong'
            :                        'cards_skipped';

  await db.query(
    `UPDATE sessions SET ${col} = ${col} + 1 WHERE id = ?`,
    [sessionId]
  );
}

// Mark session as completed and return summary
async function complete(sessionId) {
  await db.query(
    `UPDATE sessions
     SET status = 'completed', completed_at = NOW()
     WHERE id = ?`,
    [sessionId]
  );
  return getById(sessionId);
}

// Get all cards for a session
async function getCards(sessionId) {
  const [rows] = await db.query(
    'SELECT * FROM cards WHERE session_id = ? ORDER BY position',
    [sessionId]
  );
  return rows;
}

// Bulk-insert generated cards
async function saveCards(sessionId, cards) {
  if (!cards.length) return;

  const values = cards.map((c, i) => [
    uuidv4(),
    sessionId,
    c.card_type,
    c.question,
    c.answer       || null,
    c.choices      ? JSON.stringify(c.choices) : null,
    c.correct_choice || null,
    c.explanation  || null,
    i,
  ]);

  await db.query(
    `INSERT INTO cards
      (id, session_id, card_type, question, answer, choices, correct_choice, explanation, position)
     VALUES ?`,
    [values]
  );

  // Update total_cards on session
  await db.query(
    'UPDATE sessions SET total_cards = ? WHERE id = ?',
    [cards.length, sessionId]
  );

  return getCards(sessionId);
}

module.exports = { create, getById, recordCardResult, complete, getCards, saveCards };
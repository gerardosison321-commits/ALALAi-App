const sessionService = require('../services/session.service');
const layaService    = require('../services/laya.service');
const topicsService  = require('../services/topics.service');

// POST /api/session — create session + generate cards
async function create(req, res, next) {
  try {
    const { topicId, gradeLevel, subject, language, content } = req.body;

    // Get lesson content — either from uploaded text or pre-loaded topic
    let lessonContent = content;
    if (!lessonContent && topicId) {
      const topic = await topicsService.getById(topicId);
      if (!topic) return res.status(404).json({ success: false, error: 'Topic not found' });
      lessonContent = topic.content;
    }

    if (!lessonContent) {
      return res.status(400).json({ success: false, error: 'No lesson content provided.' });
    }

    // Create session record
    const session = await sessionService.create({ topicId, gradeLevel, subject, language });

    // Ask Laya to generate cards
    const rawCards = await layaService.generateCards({
      content    : lessonContent,
      gradeLevel,
      language,
      cardCount  : 8,
    });

    // Save cards to DB
    const cards = await sessionService.saveCards(session.id, rawCards);

    res.status(201).json({ success: true, data: { session, cards } });
  } catch (err) { next(err); }
}

// GET /api/session/:id
async function getOne(req, res, next) {
  try {
    const session = await sessionService.getById(req.params.id);
    if (!session) return res.status(404).json({ success: false, error: 'Session not found' });
    const cards = await sessionService.getCards(session.id);
    res.json({ success: true, data: { session, cards } });
  } catch (err) { next(err); }
}

// PATCH /api/session/:id/card/:cardId — record swipe result
async function recordResult(req, res, next) {
  try {
    const { result } = req.body; // 'correct' | 'wrong' | 'skipped'
    await sessionService.recordCardResult(req.params.id, req.params.cardId, result);
    res.json({ success: true });
  } catch (err) { next(err); }
}

// POST /api/session/:id/complete
async function complete(req, res, next) {
  try {
    const session = await sessionService.complete(req.params.id);
    res.json({ success: true, data: session });
  } catch (err) { next(err); }
}


// GET /api/session/stats?userId=xxx
async function getStats(req, res, next) {
  try {
    const { userId } = req.query;
    if (!userId) {
      return res.status(400).json({ success: false, error: 'userId required' });
    }

    const [rows] = await pool.execute(
      `SELECT subject, COUNT(*) as completed 
       FROM sessions 
       WHERE user_id = ? AND status = 'completed' 
       GROUP BY subject`,
      [userId]
    );

    res.json({ success: true, data: rows });
  } catch (err) { next(err); }
}

// Add to module.exports:
module.exports = { create, getOne, recordResult, complete, getStats };

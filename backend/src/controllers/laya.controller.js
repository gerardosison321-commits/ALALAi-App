const layaService   = require('../services/laya.service');
const sessionService = require('../services/session.service');
const topicsService  = require('../services/topics.service');

// Helper: get lesson content for a session
async function getContent(session) {
  if (session.topic_id) {
    const topic = await topicsService.getById(session.topic_id);
    return topic ? topic.content : null;
  }
  return null; // uploaded content stored separately — passed in body
}

// POST /api/laya/reexplain
async function reExplain(req, res, next) {
  try {
    const { sessionId, question, previousExplanation, content } = req.body;

    const session = await sessionService.getById(sessionId);
    if (!session) return res.status(404).json({ success: false, error: 'Session not found' });

    const lessonContent = content || await getContent(session);
    if (!lessonContent) {
      return res.status(400).json({ success: false, error: 'No lesson content available.' });
    }

    const explanation = await layaService.reExplain({
      question,
      previousExplanation,
      gradeLevel: session.grade_level,
      language  : session.language,
      content   : lessonContent,
    });

    res.json({ success: true, data: { explanation } });
  } catch (err) { next(err); }
}

// POST /api/laya/chat
async function chat(req, res, next) {
  try {
    const { sessionId, message, content } = req.body;

    const session = await sessionService.getById(sessionId);
    if (!session) return res.status(404).json({ success: false, error: 'Session not found' });

    const lessonContent = content || await getContent(session);
    if (!lessonContent) {
      return res.status(400).json({ success: false, error: 'No lesson content available.' });
    }

    const reply = await layaService.chat({
      sessionId,
      userMessage: message,
      gradeLevel : session.grade_level,
      language   : session.language,
      content    : lessonContent,
    });

    res.json({ success: true, data: { reply } });
  } catch (err) { next(err); }
}

module.exports = { reExplain, chat };
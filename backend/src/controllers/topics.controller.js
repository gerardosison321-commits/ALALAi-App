const topicsService = require('../services/topics.service');

async function list(req, res, next) {
  try {
    const { subject, grade_level } = req.query;
    const topics = await topicsService.getFiltered({
      subject,
      gradeLevel: grade_level,
    });
    res.json({ success: true, data: topics });
  } catch (err) { next(err); }
}

async function getOne(req, res, next) {
  try {
    const topic = await topicsService.getById(req.params.id);
    if (!topic) return res.status(404).json({ success: false, error: 'Topic not found' });
    res.json({ success: true, data: topic });
  } catch (err) { next(err); }
}

module.exports = { list, getOne };
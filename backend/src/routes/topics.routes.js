const router     = require('express').Router();
const controller = require('../controllers/topics.controller');

// GET /api/topics?subject=math&grade_level=7
router.get('/', controller.list);

// GET /api/topics/:id
router.get('/:id', controller.getOne);

module.exports = router;
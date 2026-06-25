const router     = require('express').Router();
const { body }   = require('express-validator');
const validate   = require('../middlewares/validate.middleware');
const controller = require('../controllers/session.controller');

// POST /api/session
router.post('/',
  [
    body('gradeLevel').isInt({ min: 1, max: 12 }).withMessage('gradeLevel must be 1–12'),
    body('subject').notEmpty().withMessage('subject is required'),
  ],
  validate,
  controller.create
);

// GET /api/session/:id
router.get('/:id', controller.getOne);

// PATCH /api/session/:id/card/:cardId
router.patch('/:id/card/:cardId',
  [body('result').isIn(['correct', 'wrong', 'skipped']).withMessage('Invalid result')],
  validate,
  controller.recordResult
);

// POST /api/session/:id/complete
router.post('/:id/complete', controller.complete);

module.exports = router;
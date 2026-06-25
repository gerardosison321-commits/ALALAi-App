const router     = require('express').Router();
const { body }   = require('express-validator');
const validate   = require('../middlewares/validate.middleware');
const controller = require('../controllers/laya.controller');

// POST /api/laya/reexplain
router.post('/reexplain',
  [
    body('sessionId').notEmpty().withMessage('sessionId is required'),
    body('question').notEmpty().withMessage('question is required'),
  ],
  validate,
  controller.reExplain
);

// POST /api/laya/chat
router.post('/chat',
  [
    body('sessionId').notEmpty().withMessage('sessionId is required'),
    body('message').notEmpty().withMessage('message is required'),
  ],
  validate,
  controller.chat
);

module.exports = router;
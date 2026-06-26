const router = require('express').Router();
const { body } = require('express-validator');
const validate = require('../middlewares/validate.middleware');
const controller = require('../controllers/auth.controller');

// POST /api/auth/register
router.post('/register',
  [
    body('name').notEmpty().withMessage('Name is required'),
    body('email').isEmail().withMessage('Valid email is required'),
    body('password').isLength({ min: 4 }).withMessage('Password min 4 characters'),
    body('gradeLevel').isInt({ min: 1, max: 12 }).withMessage('Grade 1-12 required'),
  ],
  validate,
  controller.register
);

// POST /api/auth/login
router.post('/login',
  [
    body('email').isEmail().withMessage('Valid email is required'),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  validate,
  controller.login
);

// GET /api/auth/me?userId=xxx
router.get('/me', controller.getMe);

module.exports = router;
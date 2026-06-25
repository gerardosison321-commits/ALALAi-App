const { validationResult } = require('express-validator');

// Run after express-validator checks; returns 400 if any fail
module.exports = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      errors : errors.array().map(e => ({ field: e.path, message: e.msg })),
    });
  }
  next();
};
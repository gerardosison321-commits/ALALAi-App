const uploadService = require('../services/upload.service');

async function upload(req, res, next) {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, error: 'No file uploaded.' });
    }

    const text = await uploadService.extract(req.file.path);
    uploadService.cleanup(req.file.path);

    if (!text || text.length < 20) {
      return res.status(422).json({
        success: false,
        error  : 'Could not extract readable text from the file. Please try a clearer image or PDF.',
      });
    }

    res.json({ success: true, data: { content: text } });
  } catch (err) {
    if (req.file) uploadService.cleanup(req.file.path);
    next(err);
  }
}

module.exports = { upload };
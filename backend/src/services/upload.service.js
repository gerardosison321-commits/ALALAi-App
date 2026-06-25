const fs      = require('fs');
const path    = require('path');
const pdf     = require('pdf-parse');
const claude  = require('../config/claude');

const MODEL = 'claude-sonnet-4-6';

// Extract text from an uploaded PDF
async function extractFromPDF(filePath) {
  const dataBuffer = fs.readFileSync(filePath);
  const data       = await pdf(dataBuffer);
  return data.text.trim();
}

// Extract text from an image using Claude Vision
async function extractFromImage(filePath) {
  const imageBuffer  = fs.readFileSync(filePath);
  const base64       = imageBuffer.toString('base64');
  const ext          = path.extname(filePath).toLowerCase();
  const mediaTypeMap = {
    '.jpg' : 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png' : 'image/png',
    '.webp': 'image/webp',
  };
  const mediaType = mediaTypeMap[ext] || 'image/jpeg';

  const response = await claude.messages.create({
    model     : MODEL,
    max_tokens: 2048,
    messages  : [{
      role   : 'user',
      content: [
        {
          type  : 'image',
          source: { type: 'base64', media_type: mediaType, data: base64 },
        },
        {
          type: 'text',
          text: 'Extract ALL text from this image exactly as written. This is a Filipino student\'s textbook or worksheet. Return only the extracted text, no commentary.',
        },
      ],
    }],
  });

  return response.content[0].text.trim();
}

// Auto-detect file type and extract
async function extract(filePath) {
  const ext = path.extname(filePath).toLowerCase();

  if (ext === '.pdf') {
    return extractFromPDF(filePath);
  }
  if (['.jpg', '.jpeg', '.png', '.webp'].includes(ext)) {
    return extractFromImage(filePath);
  }

  throw new Error(`Unsupported file type: ${ext}`);
}

// Clean up temp file after processing
function cleanup(filePath) {
  try {
    if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
  } catch (e) {
    console.warn('Could not delete temp file:', filePath);
  }
}

module.exports = { extract, cleanup };
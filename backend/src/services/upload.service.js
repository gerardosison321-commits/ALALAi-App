const fs = require("fs");
const path = require("path");
const pdf = require("pdf-parse");

// Extract text from PDF
async function extractFromPDF(filePath) {
  const dataBuffer = fs.readFileSync(filePath);
  const data = await pdf(dataBuffer);
  return data.text.trim();
}

// Temporary placeholder for image OCR
async function extractFromImage(filePath) {
  throw new Error(
    "Image OCR is temporarily disabled. Please upload a PDF instead."
  );
}

// Auto-detect file type
async function extract(filePath) {
  const ext = path.extname(filePath).toLowerCase();

  if (ext === ".pdf") {
    return extractFromPDF(filePath);
  }

  if ([".jpg", ".jpeg", ".png", ".webp"].includes(ext)) {
    return extractFromImage(filePath);
  }

  throw new Error(`Unsupported file type: ${ext}`);
}

// Delete temporary uploaded file
function cleanup(filePath) {
  try {
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }
  } catch (err) {
    console.warn("Could not delete temp file:", filePath);
  }
}

module.exports = {
  extract,
  cleanup,
};
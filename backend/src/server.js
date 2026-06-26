require('dotenv').config();
const express = require('express');
const cors    = require('cors');

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));

// ── Health check ──────────────────────────────────────────
app.get('/', (_, res) => res.json({
  status : 'ok',
  message: 'ALALAi Backend 🟢',
  version: '1.0.0',
}));

// ── Routes ────────────────────────────────────────────────
app.use('/api/laya',    require('./routes/laya.routes'));
app.use('/api/session', require('./routes/session.routes'));
app.use('/api/topics',  require('./routes/topics.routes'));
app.use('/api/upload',  require('./routes/upload.routes'));
app.use('/api/auth', require('./routes/auth.routes'));

// ── Global error handler (must be last) ──────────────────
app.use(require('./middlewares/error.middleware'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`\n🟢  ALALAi backend running on http://localhost:${PORT}`);
  console.log(`📚  Routes: /api/laya  /api/session  /api/topics  /api/upload\n`);
});
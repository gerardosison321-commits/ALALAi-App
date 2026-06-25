const claude = require('../config/claude');
const db     = require('../config/db');

const MODEL = 'claude-sonnet-4-6';

// ── System prompt for Laya ────────────────────────────────
function buildSystemPrompt(language, gradeLevel) {
  const langInstr =
    language === 'filipino' ? 'Sumagot ka palagi sa Filipino.'
  : language === 'english'  ? 'Always respond in English.'
  :                           'You may respond in a natural mix of Filipino and English (Taglish). Use whichever feels more natural for each explanation.';

  return `Ikaw si Laya, ang AI tutor ng ALALAi App para sa mga mag-aaral sa Pilipinas.
${langInstr}
Ang estudyante ay nasa Grade ${gradeLevel}.

Mga panuntunan mo:
- Maging mainit, mapagpasensya, at nakakaaliw — tulad ng isang kuya o ate
- Ipaliwanag ang mga konsepto sa simpleng paraan na naiintindihan ng Grade ${gradeLevel} na estudyante
- Gumamit ng mga halimbawa mula sa pang-araw-araw na buhay ng mga Pilipino
- HUWAG sumagot sa mga tanong na wala sa ibinigay na lesson material
- Kung hindi malinaw sa materyal, sabihin: "Hindi ito sakop ng ating aralin ngayon."
- Laging i-encourage ang estudyante`;
}

// ── Generate a deck of cards from lesson content ──────────
async function generateCards({ content, gradeLevel, language, cardCount = 8 }) {
  const system = buildSystemPrompt(language, gradeLevel);

  const prompt = `Batay sa sumusunod na lesson material, gumawa ng ${cardCount} learning cards para sa isang swipe-based study app.

LESSON MATERIAL:
${content}

Gumawa ng halo ng mga uri ng cards:
- concept (ipaliwanag ang pangunahing ideya)
- quiz (multiple choice na may 4 na choices: A, B, C, D)
- did_you_know (kawili-wiling katotohanan)
- challenge (mas mahirap na tanong)

Sumagot LAMANG ng valid JSON array. Walang ibang teksto. Format:
[
  {
    "card_type": "concept",
    "question": "Ano ang ...",
    "answer": "Ang ... ay ...",
    "choices": null,
    "correct_choice": null,
    "explanation": "Karagdagang paliwanag..."
  },
  {
    "card_type": "quiz",
    "question": "Alin sa mga sumusunod ang ...?",
    "answer": null,
    "choices": ["A. ...", "B. ...", "C. ...", "D. ..."],
    "correct_choice": "A",
    "explanation": "Tama ang A dahil..."
  }
]`;

  const response = await claude.messages.create({
    model     : MODEL,
    max_tokens: 4096,
    system,
    messages  : [{ role: 'user', content: prompt }],
  });

  const raw  = response.content[0].text.trim();
  // Strip markdown fences if present
  const json = raw.replace(/^```json\s*/i, '').replace(/```\s*$/i, '').trim();

  try {
    return JSON.parse(json);
  } catch {
    throw new Error('Laya returned invalid JSON for cards: ' + json.slice(0, 200));
  }
}

// ── Re-explain a card when student swipes left ────────────
async function reExplain({ question, previousExplanation, gradeLevel, language, content }) {
  const system = buildSystemPrompt(language, gradeLevel);

  const prompt = `Ang estudyante ay hindi pa naiintindihan ang sumusunod:

TANONG: ${question}
NAKARAANG PALIWANAG: ${previousExplanation || '(wala pa)'}

LESSON MATERIAL:
${content}

Ipaliwanag muli sa ibang paraan. Gumamit ng mas simpleng salita, isang halimbawa mula sa totoong buhay, o isang maikling kwento. Maging maikli (3-4 pangungusap lamang).`;

  const response = await claude.messages.create({
    model     : MODEL,
    max_tokens: 512,
    system,
    messages  : [{ role: 'user', content: prompt }],
  });

  return response.content[0].text.trim();
}

// ── Chat with Laya (grounded in lesson content) ───────────
async function chat({ sessionId, userMessage, gradeLevel, language, content }) {
  // Load conversation history from DB
  const [history] = await db.query(
    `SELECT role, content FROM chat_messages
     WHERE session_id = ?
     ORDER BY created_at ASC
     LIMIT 20`,
    [sessionId]
  );

  const system = buildSystemPrompt(language, gradeLevel) +
    `\n\nLESSON MATERIAL (ang iyong pinagbabatayan ng mga sagot):\n${content}`;

  const messages = [
    ...history.map(h => ({ role: h.role, content: h.content })),
    { role: 'user', content: userMessage },
  ];

  const response = await claude.messages.create({
    model     : MODEL,
    max_tokens: 1024,
    system,
    messages,
  });

  const reply = response.content[0].text.trim();

  // Persist both sides of the conversation
  await db.query(
    'INSERT INTO chat_messages (session_id, role, content) VALUES (?, ?, ?), (?, ?, ?)',
    [sessionId, 'user', userMessage, sessionId, 'assistant', reply]
  );

  return reply;
}

module.exports = { generateCards, reExplain, chat };
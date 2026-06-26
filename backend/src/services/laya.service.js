const groq = require("../config/groq");
const db = require("../config/db");

const MODEL = process.env.GROQ_MODEL || "llama-3.3-70b-versatile";

// ── System prompt for Laya ────────────────────────────────
function buildSystemPrompt(language, gradeLevel) {
  const langInstr =
    language === "filipino"
      ? "Sumagot ka palagi sa Filipino."
      : language === "english"
      ? "Always respond in English."
      : "You may respond in a natural mix of Filipino and English (Taglish). Use whichever feels more natural for each explanation.";

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
async function generateCards({
  content,
  gradeLevel,
  language,
  cardCount = 8,
}) {
  const system = buildSystemPrompt(language, gradeLevel);

  const prompt = `Batay sa sumusunod na lesson material, gumawa ng ${cardCount} learning cards para sa isang swipe-based study app.

LESSON MATERIAL:
${content}

Gumawa ng halo ng mga uri ng cards:
- concept (ipaliwanag ang pangunahing ideya)
- quiz (multiple choice na may 4 na choices: A, B, C, D)
- did_you_know (kawili-wiling katotohanan)
- challenge (mas mahirap na tanong)

Sumagot LAMANG ng valid JSON array. Walang markdown. Walang paliwanag.

Format:
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
    "choices": [
      "A. ...",
      "B. ...",
      "C. ...",
      "D. ..."
    ],
    "correct_choice": "A",
    "explanation": "Tama ang A dahil..."
  }
]`;

  const completion = await groq.chat.completions.create({
    model: MODEL,
    temperature: 0.4,
    response_format: { type: "json_object" },
    messages: [
      {
        role: "system",
        content: system,
      },
      {
        role: "user",
        content: `Return this as:

{
  "cards": [ ... ]
}

${prompt}`,
      },
    ],
  });

  const raw = completion.choices[0].message.content;

  try {
    const parsed = JSON.parse(raw);

    if (Array.isArray(parsed)) return parsed;
    if (Array.isArray(parsed.cards)) return parsed.cards;

    throw new Error("No cards array found.");
  } catch (err) {
    console.error(raw);
    throw new Error(
      "Groq returned invalid JSON while generating cards."
    );
  }
}

// ── Re-explain a card when student swipes left ────────────
async function reExplain({
  question,
  previousExplanation,
  gradeLevel,
  language,
  content,
}) {
  const system = buildSystemPrompt(language, gradeLevel);

  const prompt = `Ang estudyante ay hindi pa naiintindihan ang sumusunod:

TANONG:
${question}

NAKARAANG PALIWANAG:
${previousExplanation || "(wala pa)"}

LESSON MATERIAL:
${content}

Ipaliwanag muli sa ibang paraan.

Mga panuntunan:
- Gumamit ng mas simpleng salita.
- Gumamit ng isang halimbawa mula sa totoong buhay.
- Maging parang nagtuturo ang isang mabait na kuya o ate.
- 3–4 pangungusap lamang.
`;

  const completion = await groq.chat.completions.create({
    model: MODEL,
    temperature: 0.5,
    messages: [
      {
        role: "system",
        content: system,
      },
      {
        role: "user",
        content: prompt,
      },
    ],
  });

  return completion.choices[0].message.content.trim();
}

// ── Chat with Laya (grounded in lesson content) ───────────
async function chat({
  sessionId,
  userMessage,
  gradeLevel,
  language,
  content,
}) {
  // Load previous conversation
  const [history] = await db.query(
    `SELECT role, content
     FROM chat_messages
     WHERE session_id = ?
     ORDER BY created_at ASC
     LIMIT 20`,
    [sessionId]
  );

  const system =
    buildSystemPrompt(language, gradeLevel) +
    `

LESSON MATERIAL:
${content}

IMPORTANT RULES:
- Only answer using the lesson material.
- If the answer is not in the lesson, reply:
"Hindi ito sakop ng ating aralin ngayon."
- Keep answers short and easy to understand.
- Encourage the student after each answer.`;

  const messages = [
    {
      role: "system",
      content: system,
    },
    ...history.map((msg) => ({
      role: msg.role,
      content: msg.content,
    })),
    {
      role: "user",
      content: userMessage,
    },
  ];

  const completion = await groq.chat.completions.create({
    model: MODEL,
    temperature: 0.5,
    messages,
  });

  const reply = completion.choices[0].message.content.trim();

  // Save conversation
  await db.query(
    `INSERT INTO chat_messages
      (session_id, role, content)
      VALUES
      (?, ?, ?),
      (?, ?, ?)`,
    [
      sessionId,
      "user",
      userMessage,
      sessionId,
      "assistant",
      reply,
    ]
  );

  return reply;
}

module.exports = {
  generateCards,
  reExplain,
  chat,
};
const dotenv = require("dotenv");
dotenv.config();

console.log("GROQ_API_KEY =", process.env.GROQ_API_KEY);

const Groq = require("groq-sdk");

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

module.exports = groq;
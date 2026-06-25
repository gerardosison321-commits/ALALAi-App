<div align="center">

## INNOVASION
Dimaculangan, Simon
Gallon, Jason
Pardo, Miguel
Sison, Gerardo 

Project case chosen: AI-Powered Study Companion for Filipino Learners.


# ALALAi App
### AI-Powered Study Companion for Filipino Learners

[![Flutter](https://img.shields.io/badge/Built%20With-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![Powered by Claude](https://img.shields.io/badge/Powered%20By-Claude%20AI-orange)](https://www.anthropic.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Hackathon](https://img.shields.io/badge/Hackathon-Accenture%20Project%20Case-purple)]()

</div>

---

ALALAi App is an AI-powered study companion built specifically for Filipino learners. At its heart is **Laya**, a friendly AI tutor who speaks both Filipino and English, explains lessons the way students actually understand, and never leaves a learner behind regardless of where they are or what device they have.

But what makes ALALAi App truly different is **how** students learn: by swiping.

Filipino students already spend hours swiping through TikTok, Instagram Reels, and Facebook Shorts. ALALAi App takes that same instinct, that same thumb movement they already know, and redirects it toward something that actually builds their future. We call it **Doom Swipe**. Instead of mindlessly scrolling content that disappears from memory, every swipe moves a student forward. Swipe right, you got it. Swipe left, Laya explains it again, differently, better, until it clicks.

---

## The Problem We Are Solving

Millions of Filipino students face the same struggle every day. They go home with a DepEd module they barely understand, no tutor they can afford, and an internet connection that cuts in and out. Existing learning platforms assume fast internet, assume English fluency, and assume a one-size-fits-all approach to learning. For a Grade 5 student in Cebu or a high schooler in Mindanao, those platforms simply do not work.

And while those students sit with unanswered questions, their phones are already in their hands, swiping.

**ALALAi App meets them exactly there.**

---

## How It Works

When a student opens ALALAi App, they are greeted by Laya. From there, they either upload their own material, a PDF of their module or a photo of their textbook page, or they simply pick their grade level and subject and Laya loads a ready-to-go lesson built from official DepEd materials.

Then the swiping begins.

Laya generates a deck of smart cards from the student's material. Each card is short, clear, and written at the student's grade level in Filipino, English, or a natural mix of both. The student swipes through:

| Swipe | Action |
|-------|--------|
| Right | Got it! Move forward |
| Left | Hindi pa. Laya explains it again, differently |
| Up | Give me a practice exercise |
| Down | Skip for now, come back later |

Quiz cards come with a **timer** to simulate real exam conditions. A **Focus Mode** keeps the student locked in until the session is complete. The session ends with a score summary showing what the student got right, what needs review, and where to go next.

At any point, the student can open the **chat with Laya** directly. They type their question in Filipino or English and Laya answers using only the content from their lesson. No off-topic answers. No confusion. Just a direct explanation grounded in what they are actually studying.

---

## Features

**Doom Swipe Learning Cards**

Laya generates a personalized deck of cards from the student's own material or pre-loaded DepEd content. Every swipe is a decision. Every session builds mastery, one thumb movement at a time.

| Card Type | What It Does |
|-----------|-------------|
| Concept Card | Laya explains the key idea simply |
| Quiz Card | Multiple choice with instant feedback |
| Did You Know | Fun and memorable related facts |
| Challenge Card | Harder question to test mastery |
| Answer Reveal | Correct answer with full explanation |
| Achievement Card | Encouragement and milestone celebration |

**Upload Your Own Material**

Students can upload their exact lesson and Laya builds a session from it. No generic content and no off-topic answers.

- PDF modules or reviewers
- Photos of textbook pages or worksheets
- Camera capture of handwritten notes

**Pre-loaded DepEd Materials**

No file? No problem. ALALAi App ships with simplified and grade-appropriate versions of official DepEd content, ready to use offline with no upload needed.

| Subject | Coverage |
|---------|----------|
| Mathematics | Linear equations, fractions, geometry, and more |
| Science | Cells, ecosystems, matter, and more |
| Filipino | Mga uri ng pangungusap, panitikan, and more |
| English | Parts of speech, reading comprehension, and more |
| Araling Panlipunan | Kasaysayan ng Pilipinas, heograpiya, and more |

**Chat with Laya**

Follow-up questions answered instantly, grounded only in the student's lesson material. Laya responds as a patient kuya or ate: warm, encouraging, and always at the right level.

**Timed Quiz Mode**

Quiz cards include a countdown timer to build exam confidence and simulate real test conditions.

**Focus Mode**

Students commit to finishing the session before leaving. No distractions. Real learning.

**Bilingual Support**

Full toggle between Filipino, English, and Taglish, whichever the student is most comfortable with.

---

## Why the Swipe Works

The swipe is not just a design choice. It is a behavioral one.

Gen Z students are already conditioned to swipe. Their attention is trained for short bursts of content, instant feedback, and forward momentum. Doom Swipe captures that energy and channels it into learning. Every card is a micro-lesson. Every swipe is a decision. Every session builds mastery, one thumb movement at a time.

This is not gamification for the sake of it. It is meeting students where they already are and making learning feel as natural as scrolling their feed.

---

## Getting Started

### Requirements
- Flutter SDK 3.0.0 or higher
- Dart 3.0.0 or higher
- An Anthropic API key (get one at https://console.anthropic.com)
- Android or iOS device or emulator

### Quick Setup

```bash
# 1. Clone the repository
git clone https://github.com/your-team/alalai_app.git
cd alalai_app

# 2. Install dependencies
flutter pub get

# 3. Add your Anthropic API key
# Open lib/core/services/claude_service.dart
# Replace YOUR_ANTHROPIC_API_KEY_HERE with your actual key

# 4. Run the app
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# iOS (requires Mac and Xcode)
flutter build ios --release
```

---

## Project Structure

```
alalai_app/
├── lib/
│   ├── main.dart                        <- App entry point
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart          <- Brand colors
│   │   │   ├── app_strings.dart         <- Bilingual strings
│   │   │   └── app_theme.dart           <- App-wide theme
│   │   └── services/
│   │       ├── claude_service.dart      <- Anthropic API (Laya's brain)
│   │       └── file_service.dart        <- File and image upload and extraction
│   ├── models/
│   │   ├── card_model.dart              <- Learning card data structure
│   │   ├── session_model.dart           <- Study session state
│   │   └── user_preferences.dart        <- Saved grade and language settings
│   ├── screens/
│   │   ├── splash_screen.dart           <- App intro
│   │   ├── onboarding_screen.dart       <- Grade, subject, and language picker
│   │   ├── home_screen.dart             <- Upload or choose DepEd material
│   │   ├── swipe_screen.dart            <- Core Doom Swipe experience
│   │   ├── chat_screen.dart             <- Chat with Laya
│   │   └── summary_screen.dart          <- Session results
│   └── widgets/
│       └── laya_card.dart               <- Swipeable card UI component
├── assets/
│   ├── images/                          <- App icons and Laya avatar
│   └── materials/deped/                 <- Pre-loaded DepEd content
│       ├── math/
│       ├── science/
│       ├── filipino/
│       ├── english/
│       └── araling_panlipunan/
├── pubspec.yaml                         <- Dependencies
└── README.md                            <- This file
```

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart) |
| AI Brain | Claude via Anthropic API (claude-sonnet-4-6) |
| Card Swiping | flutter_card_swiper |
| File Upload | file_picker and image_picker |
| Image and PDF Reading | Claude Vision and Document API |
| Animations | flutter_animate |
| Persistence | shared_preferences |
| Chat Rendering | flutter_markdown |

---

## Design Principles

- **Mobile-first** - Designed for smartphone screens from the ground up
- **Low-bandwidth** - Text-only cards, minimal API calls, pre-loaded content
- **Offline-friendly** - DepEd materials available without internet after first launch
- **No account needed** - Open and use instantly
- **Bilingual by default** - Filipino and English throughout, student's choice

---

## Challenge Alignment

Built for the **Accenture Project Case: AI-Powered Study Companion for Filipino Learners.**

| Requirement | How ALALAi App Addresses It |
|-------------|--------------------------|
| Explain concepts in Filipino and English | Full bilingual toggle: Filipino, English, Taglish |
| Personalized to grade level | Grade selector so Laya adjusts language, difficulty, and examples |
| Generate practice exercises | Swipe up on any card for an instant AI-generated exercise |
| Mobile-friendly | Swipe-based UI built natively for Flutter mobile |
| Low-bandwidth optimized | Text-only cards, pre-loaded DepEd content, single upload per session |
| Accessible regardless of location | Pre-loaded materials work without constant internet |

---

## Meet Laya

**Laya** is ALALAi App's AI tutor, named from within the word *alalay* (to support), and also meaning *kalayaan* (freedom). Laya represents the freedom that comes with accessible education: the freedom to learn at your own pace, in your own language, wherever you are.

Laya is powered by **Claude (Anthropic)** and designed to behave as a patient and encouraging Filipino tutor, warm like a kuya or ate, never condescending, always adapting to the student's level, and never giving up on making a concept click.


---

</div>

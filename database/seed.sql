-- ============================================================
--  ALALAi Seed Data — Sample DepEd Topics
-- ============================================================

USE alalayai;

INSERT INTO topics (subject, grade_level, title, description, content, language) VALUES

-- ── MATH Grade 7 ─────────────────────────────────────────
('math', 7, 'Linear Equations in One Variable',
 'Pag-unawa sa linear equations at kung paano sila sosolusyunan.',
 'Ang linear equation in one variable ay isang equation na may iisang variable na ang pinakamataas na exponent ay 1.
Halimbawa: 2x + 3 = 7

Paraan ng pagsosolve:
1. Ilipat ang mga constant sa isang panig: 2x = 7 - 3 = 4
2. I-divide ang dalawang panig sa coefficient ng variable: x = 4 / 2 = 2
3. I-check: 2(2) + 3 = 4 + 3 = 7 ✓

Mahalagang tandaan:
- Kung ano ang gawin sa isang panig, gawin din sa kabila
- Ang layunin ay ma-isolate ang variable
- Laging i-check ang sagot sa original na equation',
 'mixed'),

-- ── SCIENCE Grade 7 ──────────────────────────────────────
('science', 7, 'Ang Cell: Yunit ng Buhay',
 'Pag-aaral ng cell bilang pangunahing yunit ng lahat ng nabubuhay.',
 'Ang cell ay ang pinakamaliit na yunit ng buhay. Lahat ng nabubuhay na bagay ay gawa sa cells.

Dalawang pangunahing uri ng cell:
1. Prokaryotic Cell - walang tunay na nucleus (halimbawa: bacteria)
2. Eukaryotic Cell - may tunay na nucleus (halimbawa: plant at animal cells)

Mga pangunahing bahagi ng cell:
- Cell Membrane: nagpoprotekta sa cell at nagkokontrol ng pagpasok at paglabas ng mga sustansya
- Nucleus: ang "utak" ng cell, naglalaman ng DNA
- Cytoplasm: ang gel-like na substance sa loob ng cell
- Mitochondria: "powerhouse" ng cell, gumagawa ng energy (ATP)
- Ribosomes: gumagawa ng protina

Pagkakaiba ng Plant at Animal Cell:
- Ang plant cell ay may cell wall, chloroplast, at malaking vacuole
- Ang animal cell ay walang cell wall at chloroplast',
 'mixed'),

-- ── FILIPINO Grade 7 ─────────────────────────────────────
('filipino', 7, 'Mga Uri ng Pangungusap',
 'Pag-aaral ng apat na uri ng pangungusap batay sa layunin.',
 'Ang pangungusap ay isang grupo ng mga salitang nagpapahayag ng isang ganap na kaisipan.

Apat na Uri ng Pangungusap Batay sa Layunin:

1. PASALAYSAY - nagbibigay ng impormasyon o nagsasalaysay ng katotohanan
   Halimbawa: Masipag ang mga Pilipino.
   Tandaan: Nagtatapos sa tuldok (.)

2. PATANONG - nagtatanong o humihingi ng sagot
   Halimbawa: Nasaan na ang iyong assignment?
   Tandaan: Nagtatapos sa tandang pananong (?)

3. PAUTOS - nag-uutos, humihiling, o nagpapayo
   Halimbawa: Linisin mo ang iyong silid.
   Tandaan: Nagtatapos sa tuldok (.) o tandang padamdam (!)

4. PADAMDAM - nagpapahayag ng malakas na damdamin
   Halimbawa: Napakaganda ng Pilipinas!
   Tandaan: Nagtatapos sa tandang padamdam (!)',
 'filipino'),

-- ── ENGLISH Grade 7 ──────────────────────────────────────
('english', 7, 'Parts of Speech',
 'Understanding the eight parts of speech in English grammar.',
 'The eight parts of speech are the building blocks of the English language.

1. NOUN - names a person, place, thing, or idea
   Examples: teacher, Manila, book, happiness

2. PRONOUN - replaces a noun
   Examples: I, you, he, she, it, we, they

3. VERB - shows action or state of being
   Examples: run, eat, is, are, was

4. ADJECTIVE - describes a noun or pronoun
   Examples: beautiful, tall, three, happy

5. ADVERB - describes a verb, adjective, or another adverb
   Examples: quickly, very, well, too

6. PREPOSITION - shows relationship between nouns
   Examples: in, on, at, under, beside

7. CONJUNCTION - connects words, phrases, or clauses
   Examples: and, but, or, so, because

8. INTERJECTION - expresses sudden emotion
   Examples: Oh! Wow! Ouch! Hey!

Remember: A word can be different parts of speech depending on how it is used in a sentence.',
 'english'),

-- ── ARALING PANLIPUNAN Grade 7 ───────────────────────────
('araling_panlipunan', 7, 'Kasaysayan ng Pilipinas: Panahon ng Espanyol',
 'Pag-aaral ng kolonyal na panahon ng Pilipinas sa ilalim ng Espanya.',
 'Nagsimula ang pananakop ng Espanya sa Pilipinas noong 1565 nang magtayo si Miguel Lopez de Legazpi ng permanenteng pamayanan sa Cebu.

Mga Mahahalagang Pangyayari:
- 1521: Pagdating ni Ferdinand Magellan sa Pilipinas
- 1565: Simula ng pananakop ng Espanya sa pamumuno ni Legazpi
- 1571: Naging kabisera ng Pilipinas ang Maynila
- 1896: Simula ng Himagsikan laban sa Espanya
- 1898: Pagtatapos ng pananakop ng Espanya

Epekto ng Kolonyalismo:
1. Relihiyon - Kumalat ang Kristiyanismo sa buong kapuluan
2. Edukasyon - Itinatag ang mga paaralan ng mga prayle
3. Wika - Naimpluwensyahan ang wikang Filipino ng Espanyol
4. Kultura - Nagbago ang mga kaugalian at tradisyon
5. Ekonomiya - Nagsimula ang sistemang encomienda

Mga Bayaning Pilipino:
- Lapu-Lapu: unang pambansang bayani, pumatay kay Magellan
- Andres Bonifacio: itinatag ang Katipunan
- Emilio Aguinaldo: unang presidente ng Pilipinas',
 'filipino');
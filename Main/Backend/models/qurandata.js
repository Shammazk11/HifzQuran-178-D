const mongoose = require("mongoose");

// Define a schema
const verseSchema = new mongoose.Schema({
  id: Number,
  text: String,
});

const surahSchema = new mongoose.Schema({
  id: Number,
  name: String,
  transliteration: String,
  type: String,
  total_verses: Number,
  verses: [verseSchema],
});

// Define a model
const Surah = mongoose.model("Surah", surahSchema);
module.exports = Surah;

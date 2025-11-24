const mongoose = require("mongoose");

const sessionSchema = new mongoose.Schema({
  goal: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Goal", // Reference to the Goal schema
    required: true,
  },
  sessionNumber: {
    type: Number,
    required: true,
  },
  ayahs: [
    {
      para: { type: String, required: true },
      surah: { type: String, required: true },
      ayah: { type: Number, required: true },
      text: { type: String, required: true }, // Add text field for reference
    },
  ],
  status: {
    type: String,
    enum: ["pending", "in-progress", "completed"],
    default: "pending",
  },
  totalAyahs: {
    type: Number,
    default: function () {
      return this.ayahs.length;
    },
  },
  completedAyahs: {
    type: Number,
    default: 0,
  },
  completedAt: {
    type: Date,
    default: null,
  },
  performanceHistory: [
    {
      segmentIndex: { type: Number, required: true }, // Index of the ayah or combined segment
      isCombinedPhase: { type: Boolean, required: true }, // Individual or combined phase
      errorRate: { type: Number, required: true }, // Error rate from speech analysis
      correctness: [{ type: Boolean, default: null }], // Word-by-word correctness
      timestamp: { type: Date, default: Date.now }, // When the attempt was made
    },
  ],
});

const Session = mongoose.model("Session", sessionSchema);
module.exports = Session;

const mongoose = require("mongoose");

const goalSchema = new mongoose.Schema({
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", // Reference to the User schema
      required: true,
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
    quranReferences: [
      {
        para: { type: String, required: true },
        surah: { type: String, required: true },
        ayah: { type: Number, required: true },
      },
    ],
    dailyTime: {
      type: Number, 
      required: true,
    },
    sessions: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Session", 
      },
    ],
    totalSessions: {
      type: Number,
      default: function () {
        return this.sessions.length;
      },
    },
    completedSessions: {
      type: Number,
      default: 0,
    },
    progressPercentage: {
      type: Number,
      default: 0,
    },
  });
  
  const Goal = mongoose.model("Goal", goalSchema);
  module.exports = Goal;
  
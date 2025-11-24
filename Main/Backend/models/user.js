const mongoose = require("mongoose");

// Define the user schema
const userSchema = new mongoose.Schema({
  username: {
    type: String,
  },
  password: {
    type: String,
  },
  email: {
    type: String,
  },
  profilePic: {
    type: String,
    default:
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
  },
  goals: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Goal", // Reference to the Goal schema
    },
  ],
});

// Create the User model
const User = mongoose.model("User", userSchema);

module.exports = User;

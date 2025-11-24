const express = require("express");
const app = express();
const mongoose = require("mongoose");
const User = require("./models/user.js");
const Surah = require("./models/qurandata.js");
const Goal = require("./models/goals");
const Session = require("./models/sessions");
const cors = require("cors");
const nodemailer = require("nodemailer");
const cron = require("node-cron");
const bodyParser = require("body-parser");
const multer = require("multer");
const path = require("path");
const fsPromises = require("fs").promises; // Promise-based FS
const fs = require("fs"); // Synchronous FS for multer
const axios = require("axios");
const FormData = require("form-data");

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

const port = 8000;

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = path.join(__dirname, "uploads");
    // Ensure directory exists
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(
      null,
      file.fieldname + "-" + uniqueSuffix + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage: storage });
app.use('/temp_audio', express.static(path.join(__dirname, 'temp_audio')));

mongoose
  .connect(
    "mongodb+srv://AbdulSubhan:subhan123@cluster0.bwax6.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(() => console.log("MongoDB connected Successfully"))
  .catch((err) => console.error(err));

function createSessions(goal) {
  const { quranReferences, dailyTime } = goal;
  const timePerAyah = 10; // Time per ayah in minutes (adjust as needed)
  const totalTime = quranReferences.length * timePerAyah; // Total time for the goal
  const numSessions = Math.ceil(totalTime / dailyTime); // Total sessions needed

  const sessions = [];
  let ayahsPerSession = Math.floor(dailyTime / timePerAyah); // Ayahs covered in one session

  let ayahIndex = 0;
  for (let i = 0; i < numSessions; i++) {
    const sessionAyahs = quranReferences.slice(
      ayahIndex,
      ayahIndex + ayahsPerSession
    );
    sessions.push({
      sessionNumber: i + 1,
      ayahs: sessionAyahs.map((ayah) => ({
        para: ayah.para,
        surah: ayah.surah,
        ayah: ayah.ayah,
        text: ayah.text, // Include text (fetched earlier)
      })),
    });
    ayahIndex += ayahsPerSession;
  }

  // Handle any remaining ayahs
  if (ayahIndex < quranReferences.length) {
    sessions[sessions.length - 1].ayahs.push(
      ...quranReferences.slice(ayahIndex).map((ayah) => ({
        para: ayah.para,
        surah: ayah.surah,
        ayah: ayah.ayah,
        text: ayah.text, // Include text
      }))
    );
  }

  return sessions;
}

const getActiveSessions = async (userId) => {
  // Populate user's goals and sessions
  const user = await User.findById(userId)
    .populate({
      path: "goals",
      populate: { path: "sessions" },
    })
    .exec();

  if (!user) throw new Error("User not found");

  // Extract pending and in-progress sessions
  const activeSessions = [];
  user.goals.forEach((goal) => {
    goal.sessions.forEach((session) => {
      if (["pending", "in-progress", "completed"].includes(session.status)) {
        // Updated condition
        activeSessions.push({
          _id: session._id.toString(),
          goalId: session.goal._id,
          sessionNumber: session.sessionNumber,
          quranReferences: session.ayahs,
          ayahsLeft: session.totalAyahs - session.completedAyahs,
          status: session.status, // Optional: Include status for clarity
        });
      }
    });
  });

  //console.log("Active sessions (pending and in-progress):", activeSessions);
  return activeSessions;
};
const getPendingSessions = async (userId) => {
  // Populate user's goals and sessions
  const user = await User.findById(userId)
    .populate({
      path: "goals",
      populate: { path: "sessions" },
    })
    .exec();

  if (!user) throw new Error("User not found");

  // Extract pending and in-progress sessions
  const activeSessions = [];
  user.goals.forEach((goal) => {
    goal.sessions.forEach((session) => {
      if (["pending", "in-progress",].includes(session.status)) {
        // Updated condition
        activeSessions.push({
          _id: session._id.toString(),
          goalId: session.goal._id,
          sessionNumber: session.sessionNumber,
          quranReferences: session.ayahs,
          ayahsLeft: session.totalAyahs - session.completedAyahs,
          status: session.status, // Optional: Include status for clarity
        });
      }
    });
  });

  //console.log("Active sessions (pending and in-progress):", activeSessions);
  return activeSessions;
};

app.post("/googleregister", async (req, res) => {
  try {
    const { uid, name, email, photoUrl } = req.body;

    // Check if user already exists
    let user = await User.findOne({ email });
    if (user) {
      return res
        .status(400)
        .json({ message: "User with this email already exists" });
    }
    if (!user) {
      // Create new user if they don’t exist
      user = new User({
        username: name,
        email: email,
        password: null, // No password for Google users
        profilePic: photoUrl || undefined, // Use Google profile image
        goals: [],
      });

      await user.save();
    }

    res.status(200).json({
      success: true,
      message: "Google Authentication successful!",
      user,
    });
  } catch (error) {
    console.error("Google Signup Error:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
app.post("/register", async (req, res) => {
  const { email, username, password } = req.body;

  try {
    // Check if the email already exists
    const existingUser = await User.findOne({ email: email });
    if (existingUser) {
      return res
        .status(400)
        .json({ message: "User with this email already exists" });
    }

    // Create a new user
    const newUser = new User({
      email: email,
      username: username,
      password: password, // Ideally, you should hash the password before saving it
    });

    await newUser.save();
    res.status(200).json({ message: "User registered successfully" });
  } catch (error) {
    console.error("Error during registration:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
app.post("/googlelogin", async (req, res) => {
  const { uid, name, email, photoURL } = req.body;

  try {
    // Find user by email
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    if (user.email === email) {
      return res.status(200).json({ message: "Login successful", user });
    } else {
      return res.status(401).json({ message: "Invalid credentials" });
    }
  } catch (error) {
    console.error("Error during login", error);

    return res.status(500).json({ message: "Internal server error" });
  }
});

app.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    // Find user by email
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ message: "User not found" });
    }

    if (user.password === password) {
      return res.status(200).json({ message: "Login successful", user });
    } else {
      return res.status(401).json({ message: "Invalid credentials" });
    }
  } catch (error) {
    console.error("Error during login", error);

    return res.status(500).json({ message: "Internal server error" });
  }
});
// Route to fetch user data by username

app.get("/profile/:email", async (req, res) => {
  try {
    const Email = req.params.email;
    console.log(Email);

    // Find user by username in MongoDB
    const user = await User.findOne({ email: Email });

    if (user) {
      // Send the user data back to the frontend
      res.status(200).json({
        username: user.username,
        email: user.email,
        password: user.password, // Avoid sending passwords in production
        profileImageUrl: user.profilePic,
      });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

app.put("/update-profile/:email", async (req, res) => {
  const { username, password } = req.body; // Destructure the request body
  const email = req.params.email; // Get email from URL params

  if (!username && !password) {
    return res.status(400).json({ message: "No data provided to update" });
  }

  try {
    // Find user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Update username if provided
    if (username) {
      user.username = username;
    }

    // Update password if provided
    if (password) {
      user.password = password; // Use hashed password for security
    }

    // Save the updated user
    await user.save();

    res.status(200).json({ message: "User profile updated successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

app.post("/searchayah", async (req, res) => {
  const { para, surah, ayah } = req.body;

  if (!surah || !ayah) {
    return res
      .status(400)
      .send({ message: "Surah name and Ayah number are required" });
  }

  try {
    // Search the database
    const surahdata = await Surah.findOne(
      { transliteration: surah, "verses.id": ayah },
      { "verses.$": 1 }
    );

    if (!surahdata) {
      return res.status(404).send({ message: "Surah or Ayah not found" });
    }
    // Extract the Ayah text
    const ayahText = surahdata.verses[0].text;

    // Log to console
    //console.log(`Ayah Text: ${ayahText}`);

    // Send response
    res.status(200).send({ ayahText });
  } catch (error) {
    console.error("Error fetching data:", error);
    res.status(500).send({ message: "Error fetching data", error });
  }
});

app.post("/save-goals", async (req, res) => {
  const { quranReferences, email, dailyTime } = req.body;

  // Validate input
  if (!quranReferences || !Array.isArray(quranReferences)) {
    return res
      .status(400)
      .json({ message: "Goals data is required and should be an array." });
  }

  if (!dailyTime || isNaN(dailyTime) || dailyTime <= 0) {
    return res.status(400).json({ message: "Invalid daily time." });
  }

  try {
    // Find the user by email
    const user = await User.findOne({ email }).populate("goals");
    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    // Check for duplicate goals
    const duplicateGoals = quranReferences.filter((newGoal) =>
      user.goals.some((existingGoal) =>
        existingGoal.quranReferences.some(
          (ref) =>
            ref.para === newGoal.para &&
            ref.surah === newGoal.surah &&
            ref.ayah === newGoal.ayah
        )
      )
    );

    if (duplicateGoals.length > 0) {
      return res.status(400).json({
        message: "Some or all goals already exist.",
        duplicateGoals,
      });
    }

    // Fetch ayah texts for all quranReferences
    const ayahsWithText = await Promise.all(
      quranReferences.map(async (ref) => {
        const surahData = await Surah.findOne(
          { transliteration: ref.surah, "verses.id": ref.ayah },
          { "verses.$": 1 }
        );

        if (!surahData || !surahData.verses.length) {
          console.log(`⚠️ Ayah ${ref.ayah} not found in Surah "${ref.surah}"`);
          return null; // Handle missing ayahs gracefully
        }

        const ayahData = surahData.verses[0];
        return {
          para: ref.para,
          surah: ref.surah,
          ayah: ref.ayah,
          text: ayahData.text, // Fetch and include text
        };
      })
    );

    const validAyahs = ayahsWithText.filter((ayah) => ayah !== null);
    if (validAyahs.length === 0) {
      return res.status(404).json({ message: "No valid ayahs found." });
    }

    // Create the new Goal
    const newGoal = new Goal({
      user: user._id,
      quranReferences: validAyahs.map((ref) => ({
        para: ref.para,
        surah: ref.surah,
        ayah: ref.ayah,
      })),
      dailyTime,
    });

    // Generate sessions for the goal with text included
    const sessions = createSessions({
      quranReferences: validAyahs, // Pass ayahs with text
      dailyTime: newGoal.dailyTime,
    });

    const sessionDocs = await Session.insertMany(
      sessions.map((s) => ({
        goal: newGoal._id,
        sessionNumber: s.sessionNumber,
        ayahs: s.ayahs, // Ayahs already include text
      }))
    );

    // Add the sessions to the goal
    newGoal.sessions = sessionDocs.map((s) => s._id);
    newGoal.totalSessions = sessions.length;

    // Save the goal
    await newGoal.save();

    // Add the goal to the user's goals array
    user.goals.push(newGoal._id);
    await user.save();

    res.status(200).json({ message: "Goals and sessions added successfully!" });
  } catch (error) {
    console.error("Error saving goals:", error);
    res.status(500).json({ message: "An error occurred while saving goals." });
  }
});

app.post("/user-goals", async (req, res) => {
  const { email } = req.body;

  try {
    const user = await User.findOne({ email }).populate({
      path: "goals",
      populate: { path: "sessions" },
    });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const goalsData = await Promise.all(
      user.goals.map(async (goal) => {
        // Count completed sessions
        const completedSessions = goal.sessions.reduce((count, session) => {
          return session.status === "completed" ? count + 1 : count;
        }, 0);

        // Update goal's completedSessions and save to DB
        goal.completedSessions = completedSessions;
        await goal.save(); // Save the updated goal document

        const progressPercentage =
          goal.totalSessions > 0
            ? (completedSessions / goal.totalSessions) * 100
            : 0;

        return {
          _id: goal._id.toString(),
          quranReferences: goal.quranReferences.map((ref) => ({
            para: ref.para,
            surah: ref.surah,
            ayah: ref.ayah,
          })),
          createdAt: goal.createdAt,
          totalSessions: goal.totalSessions,
          completedSessions: completedSessions,
          progressPercentage: progressPercentage,
        };
      })
    );

    return res.status(200).json({ goals: goalsData });
  } catch (error) {
    console.error("Error fetching user goals:", error);
    return res.status(500).json({ message: "Server error" });
  }
});

app.delete("/remove-goal", async (req, res) => {
  const { email, goalId } = req.body;
  console.log(goalId);

  if (!email || !goalId) {
    return res.status(400).json({ message: "Email and Goal ID are required." });
  }

  try {
    // Find the user and remove the specific goal
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "User not found." });
    }

    // Filter out the goal to be removed
    const updatedGoals = user.goals.filter(
      (goal) => goal._id.toString() !== goalId
    );

    // If no changes were made, it means the goal was not found
    if (updatedGoals.length === user.goals.length) {
      return res.status(404).json({ message: "Goal not found." });
    }

    // Update the user's goals array
    user.goals = updatedGoals;
    await user.save();

    // Step 4: Delete the associated sessions for the goal
    await Session.deleteMany({ goal: goalId });

    // Step 5: Delete the goal document
    await Goal.findByIdAndDelete(goalId); // Deletes the goal document

    return res
      .status(200)
      .json({ message: "Goal and associated sessions deleted successfully!" });
  } catch (error) {
    console.error("Error removing goal:", error);
    return res
      .status(500)
      .json({ message: "An error occurred while removing the goal." });
  }
});

app.post("/update-session-progress", async (req, res) => {
  const { sessionId, learnedAyahs } = req.body;

  try {
    // Find the session
    const session = await Session.findById(sessionId);
    if (!session) {
      return res.status(404).json({ message: "Session not found." });
    }

    // Update completed ayahs
    const totalAyahs = session.totalAyahs;
    const updatedCompletedAyahs = session.completedAyahs + learnedAyahs;

    if (updatedCompletedAyahs >= totalAyahs) {
      // Session completed
      session.completedAyahs = totalAyahs;
      session.status = "completed";
      session.completedAt = new Date();
      const goal = await Goal.findById(session.goal);
      goal.completedSessions += 1;
      await goal.save();
    } else {
      // Session still in progress
      session.completedAyahs = updatedCompletedAyahs;
      session.status = "in-progress";
    }

    await session.save();

    // Handle leftover ayahs if the session is completed but some ayahs are still left
    const leftoverAyahs = totalAyahs - updatedCompletedAyahs;
    if (leftoverAyahs > 0) {
      // Find the goal and its sessions
      const goal = await Goal.findById(session.goal).populate("sessions");

      const nextSessionIndex =
        goal.sessions.findIndex(
          (sess) => sess._id.toString() === session._id.toString()
        ) + 1;

      const nextSession = goal.sessions[nextSessionIndex];

      if (nextSession) {
        // Add leftover ayahs to the next session
        nextSession.ayahs = [
          ...session.ayahs.slice(-leftoverAyahs),
          ...nextSession.ayahs,
        ];
        nextSession.totalAyahs = nextSession.ayahs.length;
        await nextSession.save();
      } else {
        // Create a new session for leftover ayahs
        const newSession = new Session({
          goal: goal._id,
          sessionNumber: goal.sessions.length + 1,
          ayahs: session.ayahs.slice(-leftoverAyahs),
          totalAyahs: leftoverAyahs,
          status: "pending",
        });
        await newSession.save();

        // Add the new session to the goal
        goal.sessions.push(newSession._id);
        goal.totalSessions += 1; // Update the totalSessions count
        await goal.save();
      }
    }

    // Update goal progress
    const completedSessions = await Session.countDocuments({
      goal: session.goal,
      status: "completed",
    });

    // Update goal progress
    const sessions = await Session.find({ goal: session.goal });

    // Calculate total ayahs and completed ayahs
    //const totalAyahs1 = sessions.reduce((sum, sess) => sum + sess.totalAyahs, 0);
    const goal = await Goal.findById(session.goal);
    const totalAyahs1 = goal.quranReferences.length;
    const completedAyahs = sessions.reduce(
      (sum, sess) => sum + sess.completedAyahs,
      0
    );
    // console.log("Toatal", totalAyahs1);
    // console.log("Completed", completedAyahs);

    goal.progressPercentage = (completedAyahs / totalAyahs1) * 100;

    // Save updated goal
    await goal.save();

    res.status(200).json({ message: "Session progress updated successfully." });
  } catch (error) {
    console.error("Error updating session progress:", error);
    res
      .status(500)
      .json({ message: "An error occurred while updating session progress." });
  }
});

function formatSessionDetails(pendingSessions) {
  return pendingSessions
    .map((session) => {
      const ayahs = session.quranReferences
        .map(
          (ayah) =>
            `Para: ${ayah.para}, Surah: ${ayah.surah}, Ayah: ${ayah.ayah}`
        )
        .join("\n");

      return `
Goal:${session.goalId}
Session Number: ${session.sessionNumber}
Ayahs Left: ${session.ayahsLeft}
Ayah Details:
${ayahs}
`;
    })
    .join("\n--------------------------------\n");
}
function formatEmailContent(groupedData) {
  let emailContent = "<h1>Pending Session Details</h1>";
  for (const goalId in groupedData) {
    goaldata = goalId.slice(-2);
    emailContent += `<h2>Goal: ${goaldata}</h2>`;
    groupedData[goalId].forEach((session) => {
      emailContent += `
        <p>Session Number: ${session.sessionNumber}</p>
        <p>Ayahs Left: ${session.ayahsLeft}</p>
        <p>Quran References:</p>
        <ul>
          ${session.quranReferences
          .map(
            (ref) =>
              `<li>Para: ${ref.para}, Surah: ${ref.surah}, Ayah: ${ref.ayah}</li>`
          )
          .join("\n----------------------------------------------\n")}
        </ul>
      `;
    });
  }
  return emailContent;
}
const notifyUser = async (user, pendingSessions) => {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "abdulsubhancheema97@gmail.com",
      pass: "bgzo akuy oaqv xmif",
    },
  });
  // Group sessions by goalId
  const groupedData = pendingSessions.reduce((acc, session) => {
    const goalId = session.goalId.toString();
    if (!acc[goalId]) acc[goalId] = [];
    acc[goalId].push(session);
    return acc;
  }, {});

  const sessionDetails = formatEmailContent(groupedData);

  // const mailOptions = {
  //   from: "abdulsubhancheema97@gmail.com",
  //   to: user.email,
  //   subject: "Pending Quran Memorization Sessions",
  //   text: `Dear ${user.username},\n\nYou have the following pending sessions:\n\n${sessionDetails}\n\nPlease complete them at your earliest convenience.\n\nRegards,\nHifzQuran Team`,
  // };
  // Email options
  const mailOptions = {
    from: "abdulsubhancheema97@gmail.com", // Sender address
    to: user.email, // Recipient address
    subject: "Pending Quran Sessions Reminder",
    html: `${sessionDetails}\n\n\n\nPlease complete them at your earliest convenience.\n\nRegards,\nHifzQuran Team`,
  };
  await transporter.sendMail(mailOptions);
};

// cron.schedule("**/10 * * * *", async () => {
//   console.log("Running scheduled task: Notify users about pending sessions");

//   const users = await User.find(); // Fetch all users
//   for (const user of users) {
//     try {
//       const pendingSessions = await getPendingSessions(user._id);

//       if (pendingSessions.length > 0) {
//         notifyUser(user, pendingSessions); // Notify user
//       }
//     } catch (error) {
//       console.error(
//         `Error fetching pending sessions for user ${user._id}:`,
//         error
//       );
//     }
//   }
// });

app.post("/user-sessions", async (req, res) => {
  try {
    const { email } = req.body;

    // Validate input
    if (!email) {
      return res.status(400).json({ error: "Email is required" });
    }

    // Find the user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const activeSessions = await getActiveSessions(user._id); // Updated function name

    // Group sessions by goalId
    const groupedData = activeSessions.reduce((acc, session) => {
      const goalId = session.goalId.toString();
      if (!acc[goalId]) acc[goalId] = [];
      acc[goalId].push(session);
      return acc;
    }, {});

    //console.log("Grouped sessions data:", groupedData);
    res.status(200).json(groupedData);
  } catch (error) {
    console.error("Error fetching user sessions:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/clickedsessiondetail", async (req, res) => {
  try {
    //console.log("🔹 Received Data from Frontend:", req.body);

    const { _id } = req.body; // Expect sessionId as '_id'

    if (!_id || !mongoose.Types.ObjectId.isValid(_id)) {
      console.log("❌ Error: Invalid or missing session ID");
      return res.status(400).json({ error: "Invalid or missing session ID" });
    }

    // Fetch the session by ID
    const session = await Session.findById(_id).populate("goal"); // Populate goal if needed
    if (!session) {
      console.log(`❌ Session with ID ${_id} not found`);
      return res.status(404).json({ error: "Session not found" });
    }

    //console.log(`✅ Found Session: ${session.sessionNumber}`);

    // Prepare the ayahs array (already stored in the session)
    const ayahs = session.ayahs.map((ayah) => ({
      surah: ayah.surah,
      ayah: ayah.ayah,
      text: ayah.text,
    }));

    if (ayahs.length === 0) {
      console.log("❌ No ayahs found in session");
      return res.status(404).json({ error: "No ayahs found in session" });
    }

    // Prepare the response with full session details
    const response = {
      ayahs: ayahs,
      sessionNumber: session.sessionNumber,
      status: session.status,
      totalAyahs: session.totalAyahs,
      completedAyahs: session.completedAyahs,
      completedAt: session.completedAt,
      performanceHistory: session.performanceHistory,
    };

    //console.log("✅ Response prepared:", response.ayahs);

    res.json(response);
  } catch (error) {
    console.error("❌ Error fetching session details:", error);
    res.status(500).json({ error: "Server error" });
  }
});

app.post("/goal-progress", async (req, res) => {
  const { email } = req.body; // Assuming the email is sent in the request body
  console.log("Email:", email);
  try {
    // Find the user by email (you might want to replace this with user ID lookup)
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Find all goals for the user
    const goals = await Goal.find({ user: user._id });

    // Prepare the goal progress data
    const goalProgress = goals.map((goal) => ({
      goalId: goal._id,
      totalSessions: goal.totalSessions,
      completedSessions: goal.completedSessions,
      dailyTime: `${goal.dailyTime} minutes`,
      progressPercentage: goal.progressPercentage,
    }));
    // console.log(goalProgress)
    // Return the goal progress data
    res.status(200).json(goalProgress);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error fetching goal progress" });
  }
});

app.post("/checkspeech", upload.single("audio_file"), async (req, res) => {
  try {
    const originalText = req.body.original_text;
    const sessionId = req.body.sessionId;
    const segmentIndex = parseInt(req.body.segmentIndex, 10);
    const isCombinedPhase = req.body.isCombinedPhase === "true";
    const isSessionCompleted = req.body.isSessionCompleted === "true";
    const isMushabihat = req.body.isMushabihat === "true";

    console.log("Received Data from Frontend:", req.body);

    if (!originalText) {
      return res
        .status(400)
        .json({ error: "Missing original_text in request body" });
    }
    if (!sessionId) {
      return res
        .status(400)
        .json({ error: "Missing sessionId in request body" });
    }
    if (isNaN(segmentIndex)) {
      return res
        .status(400)
        .json({ error: "Missing or invalid segmentIndex in request body" });
    }

    const audioFile = req.file;
    if (!audioFile) {
      console.log("No audio file received");
      return res.status(400).json({ error: "Audio file is required" });
    }
    console.log("Audio file received:", audioFile.filename);

    const originalWords = originalText
      .trim()
      .split(" ")
      .filter((word) => word !== "•");
    if (originalWords.length === 0) {
      return res.status(400).json({ error: "original_text is empty" });
    }

    const formData = new FormData();
    formData.append("audio_file", fs.createReadStream(audioFile.path));
    formData.append("correct_ayat", originalWords.join(" ")); // Changed from originalText to originalWords.join(" ")

    // Call the evaluation endpoint
    const evaluationResponse = await axios.post(
      "https://b166-34-132-73-64.ngrok-free.app/evaluate",
      formData,
      {
        headers: {
          ...formData.getHeaders(),
        },
      }
    );

    const { error_rate, wrong_words } = evaluationResponse.data;
    console.log("Evaluation Response:", { error_rate, wrong_words });

    // Calculate correctness array based on wrong_words
    const correctness = originalWords.map(
      (word) => !wrong_words.includes(word)
    );
    const incorrectCount = wrong_words.length;

    console.log("Correctness:", correctness);
    console.log("Error rate from evaluation:", error_rate);

    const session = await Session.findById(sessionId);
    if (!session) {
      return res.status(404).json({ error: "Session not found" });
    }

    console.log("Session before update:", {
      completedAyahs: session.completedAyahs,
      totalAyahs: session.totalAyahs,
      status: session.status,
    });

    const performanceEntry = {
      segmentIndex: segmentIndex,
      isCombinedPhase: isCombinedPhase,
      errorRate: error_rate,
      correctness: correctness,
      timestamp: new Date(),
    };
    session.performanceHistory.push(performanceEntry);

    const segmentHistory = session.performanceHistory
      .filter(
        (entry) => entry.segmentIndex === segmentIndex && !entry.isCombinedPhase
      )
      .sort((a, b) => b.timestamp - a.timestamp);

    console.log(
      "Segment History (recent first):",
      segmentHistory.map((entry) => ({
        errorRate: entry.errorRate,
        timestamp: entry.timestamp,
      }))
    );

    const requiredSuccesses = isMushabihat ? 4 : 3;
    console.log("Required Successes:", requiredSuccesses);

    const recentAttempts = segmentHistory.slice(0, requiredSuccesses);
    console.log(
      "Recent Attempts:",
      recentAttempts.map((entry) => entry.errorRate)
    );

    const consecutiveSuccesses =
      recentAttempts.length >= requiredSuccesses &&
        recentAttempts.every((entry) => entry.errorRate < 0.3)
        ? requiredSuccesses
        : 0;
    console.log("Consecutive Successes:", consecutiveSuccesses);

    const priorHistory = segmentHistory.slice(1);
    console.log(
      "Prior History:",
      priorHistory.map((entry) => entry.errorRate)
    );

    const hasPriorMastery = priorHistory.some((entry, index) => {
      if (entry.errorRate >= 0.3) return false;
      const priorSlice = priorHistory.slice(
        Math.max(0, index - (requiredSuccesses - 1)),
        index + 1
      );
      console.log(
        `Checking slice at index ${index}:`,
        priorSlice.map((e) => e.errorRate)
      );
      return (
        priorSlice.length === requiredSuccesses &&
        priorSlice.every((e) => e.errorRate < 0.3)
      );
    });

    console.log("Has Prior Mastery:", hasPriorMastery);

    console.log("Condition Check:", {
      errorRateLessThan0_3: error_rate < 0.3,
      notCombinedPhase: !isCombinedPhase,
      notHasPriorMastery: !hasPriorMastery,
      consecutiveSuccessesMatches: consecutiveSuccesses === requiredSuccesses,
    });

    if (
      error_rate < 0.3 &&
      !isCombinedPhase &&
      !hasPriorMastery &&
      consecutiveSuccesses === requiredSuccesses
    ) {
      console.log(
        "Incrementing completedAyahs from",
        session.completedAyahs,
        "to",
        session.completedAyahs + 1
      );
      session.completedAyahs = Math.min(
        session.completedAyahs + 1,
        session.totalAyahs
      );
    } else {
      console.log("Not incrementing completedAyahs. Condition failed.");
    }

    if (session.completedAyahs === session.totalAyahs && !isCombinedPhase) {
      console.log("Setting status to in-progress");
      session.status = "in-progress";
    } else if (
      session.completedAyahs === session.totalAyahs &&
      isCombinedPhase &&
      isSessionCompleted
    ) {
      console.log("Setting status to completed");
      session.status = "completed";
      session.completedAt = new Date();
    } else if (error_rate < 0.3) {
      console.log("Setting status to in-progress (successful attempt)");
      session.status = "in-progress";
    }

    console.log("Session after update:", {
      completedAyahs: session.completedAyahs,
      totalAyahs: session.totalAyahs,
      status: session.status,
    });

    await session.save();

    // Clean up uploaded file
    fs.unlinkSync(audioFile.path);

    res.json({
      correctness: correctness,
      error_rate: error_rate,
      wrong_words: wrong_words,
      audio_processed: true,
      message: "Speech check completed",
    });
  } catch (error) {
    console.error("Error processing speech check:", error);
    res.status(500).json({ error: "Error processing request" });
  }
});

// Helper function example (not used yet but could be implemented later)
function saveAudioForLaterProcessing(audioPath, text) {
  // Here you would save the audio file path and associated text
  // to a database or file system for later processing
  console.log(
    `Saved audio file ${audioPath} with text: ${text} for later processing`
  );
}
const PORT = 8000;
const AUDIO_DIR = "A:\\Backend\\uploads"; // Windows path
const BASE_URL = `http://192.168.137.1:${PORT}`;


// Serve static audio files from the uploads directory

app.use("/audio", express.static(AUDIO_DIR));

// Helper function to get random .m4a audio files
async function getRandomAudioFiles(count) {
  try {
    // Check if directory is accessible using fs.promises
    try {
      await fsPromises.access(AUDIO_DIR, fsPromises.constants.R_OK);
    } catch (accessError) {
      throw new Error(`Cannot access audio directory: ${accessError.message}`);
    }

    // Read all files from audio directory
    const files = await fsPromises.readdir(AUDIO_DIR);
    const audioFiles = files.filter((file) => file.endsWith(".m4a"));

    if (audioFiles.length === 0) {
      throw new Error("No .m4a audio files found in directory");
    }

    // Shuffle array (Fisher-Yates shuffle)
    for (let i = audioFiles.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [audioFiles[i], audioFiles[j]] = [audioFiles[j], audioFiles[i]];
    }

    const selectedFiles = audioFiles.slice(
      0,
      Math.min(count, audioFiles.length)
    );
    return selectedFiles.map((file) => `${BASE_URL}/audio/${file}`);
  } catch (error) {
    console.error("Error getting random audio files:", error);
    throw error;
  }
}
const SEGMENT_API_URL = "https://d562-149-40-228-114.ngrok-free.app/quran_segmented";

app.post("/segmentchunks", async (req, res) => {
  try {
    const { surah_index, start_ayah, end_ayah, words_per_segment } = req.body;

    // Validate input
    if (
      typeof surah_index !== "number" ||
      typeof start_ayah !== "number" ||
      typeof end_ayah !== "number" ||
      typeof words_per_segment !== "number"
    ) {
      return res.status(400).json({ error: "Invalid input format" });
    }

    // Forward request to actual segment chunk API
    const response = await axios.post(SEGMENT_API_URL, {
      surah_index,
      start_ayah,
      end_ayah,
      words_per_segment
    });

    // Forward the exact response back to the frontend
    return res.status(200).json(response.data);
  } catch (error) {
    console.error("Error forwarding segment chunk request:", error.message);
    return res.status(500).json({ error: "Failed to retrieve segments" });
  }
});
// Endpoint to return random audio files based on number of ayahs

app.post("/getayahsaudio", async (req, res) => {
  try {
    const { ayah_text, ayah_data } = req.body;
    console.log("Received request to /getayahsaudio with body:", req.body);
    console.log("Received ayah_data:", ayah_data);

    if (!ayah_text || !ayah_data || !ayah_data.length) {
      console.log("Missing ayah_text or ayah_data in request body");
      return res.status(400).json({ error: "Missing ayah_text or ayah_data in request body" });
    }

    // Transform ayah_data into the external API's expected format
    const externalRequestBody = ayah_data.map((ayah, index) => ({
      ayah: ayah.ayah_number, // Ayah number (e.g., 3)
      segments: [
        {
          id: index + 1, // Simple incremental ID for each segment
          segment: ayah.text
        }
      ],
      surah: ayah.surah_number // Surah number (e.g., 1)
    }));

    // Improved logging to show full structure
    console.dir("Transformed request body for external API:", { depth: null });
    console.log(JSON.stringify(externalRequestBody, null, 2));
    // Make request to the external API for each ayah
    const audioResponses = await Promise.all(
      externalRequestBody.map(async (body) => {
        const response = await axios.post(
          'https://d562-149-40-228-114.ngrok-free.app/segment-audio',
          body,
          { responseType: 'arraybuffer' } // Expect binary data (compressed file)
        );
        return response.data;
      })
    );

    // Save the compressed files and generate URLs
    const tempDir = path.join(__dirname, 'temp_audio');
    if (!fs.existsSync(tempDir)) {
      fs.mkdirSync(tempDir);
    }

    const audioUrls = [];
    for (let i = 0; i < audioResponses.length; i++) {
      const filePath = path.join(tempDir, `audio_${Date.now()}_${i}.zip`);
      fs.writeFileSync(filePath, Buffer.from(audioResponses[i]));
      // Assuming the server can serve these files statically
      const fileUrl = `${BASE_URL}/temp_audio/${path.basename(filePath)}`;
      audioUrls.push(fileUrl);
    }

    console.log("Returning audio URLs:", audioUrls);
    res.status(200).json({ audio_urls: audioUrls });

  } catch (error) {
    console.error("Error in /getayahsaudio:", error.message);
    res.status(500).json({ error: error.message || "Internal server error" });
  }
});



app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

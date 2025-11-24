Hifz Quran Backend

This is the Node.js backend for the Hifz Quran (FYP) application. It provides RESTful endpoints for session management, speech analysis, and scheduled notifications, and connects to MongoDB for data storage.

⸻

Prerequisites

Before you begin, ensure you have the following installed:
	•	Node.js (v16 or higher) and npm
	•	MongoDB database (local instance or Atlas)
	•	Git (for cloning the repository)
	•	Gmail account with 2FA enabled and an App Password for sending emails via Nodemailer

⸻

Installation
	1.	Clone the Repository

git clone git@github.com:Abdul-SubhanCheema/FYP-HifzQuran.git
cd FYP-HifzQuran/backend


	2.	Install Dependencies

npm install


	3.	Configure Environment Variables
Create a file named .env in the backend/ directory with the following contents:

# Server port
PORT=8000

# MongoDB connection string
MONGODB_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/hifzquran?retryWrites=true&w=majority

# Gmail SMTP credentials (use an App Password, not your account password)
EMAIL_USER=your.email@gmail.com
EMAIL_PASS=your_app_password

	•	Replace <username>:<password> with your MongoDB credentials.
	•	Use your Gmail address for EMAIL_USER and the 16-character App Password for EMAIL_PASS.

⸻

Running the Backend

Development Mode

You can use nodemon to automatically restart the server on file changes:

npm install -g nodemon   # install globally if you haven't
nodemon index.js         # starts the server and watches for changes

Or run directly with:

node index.js

Production Mode

npm start

If there is no start script defined, just run node index.js.

⸻

API Endpoints

Method	Path	Description
POST	/clickedsessiondetail	Fetch session metadata and ayah list
POST	/checkspeech	Analyze uploaded audio and return scores

Note: All endpoints expect and return JSON.

⸻

Scheduled Tasks

On startup, the backend schedules a periodic task to:
	•	Notify users about pending sessions via email.

This runs automatically; you can adjust the schedule in index.js where the task is defined.

⸻
Email Setup

We use Nodemailer with Gmail’s SMTP server. Make sure:
	•	Your Gmail account has 2-step verification enabled.
	•	You’ve created an App Password (https://myaccount.google.com/apppasswords).
	•	That App Password is set as EMAIL_PASS in your .env.


	•	For speech analysis, send a multipart/form-data POST to /checkspeech with fields:
	•	original_text (string)
	•	sessionId (string)
	•	segmentIndex (number)
	•	isCombinedPhase (boolean)
	•	isSessionCompleted (boolean)
	•	isMushabihat (boolean)
	•	audio_file (binary file)

⸻

Project Structure

backend/
├── index.js               # Main server file
├── package.json           # NPM dependencies & scripts
├── .env                   # Environment variables (not in git)
├── routes/                # (if you refactored into route modules)
├── models/                # Mongoose schemas
└── utils/                 # Helper functions (email, scheduling)


⸻

Contribution

Feel free to open issues or submit pull requests. Make sure to run all tests (if added) and follow consistent coding styles.

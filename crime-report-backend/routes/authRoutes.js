const express = require("express");
const router = express.Router();
const {
  registerUser,
  loginUser,
  getUser,
} = require("../controllers/authController");

// Routes
router.post("/register", registerUser);
router.post("/login", loginUser);
// GET USER PROFILE
router.get("/profile/:id", getUser)

module.exports = router;
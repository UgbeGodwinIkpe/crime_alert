const express = require("express");

const router = express.Router();
const {
  getUser,
  updateUser,
  chnagePassword
} = require("../controllers/authController");

// GET USER PROFILE
router.get("/profile/:id", getUser)
router.put("/update/:id", updateUser)
router.put("/change-password/:id", chnagePassword)

module.exports = router;
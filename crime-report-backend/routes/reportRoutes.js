const express = require("express");
const router = express.Router();
const multer = require("multer");
const {
  createReport,
  getAllReports,
  getMyReports,
  updateReportStatus,
  deleteReport,viewReports, adminUpdateStatus,
} = require("../controllers/reportController");
const { protect } = require("../middleware/authMiddleware");  

// 🔹 MULTER CONFIG
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const upload = multer({ storage });

// 🔹 ROUTES
router.post("/", protect, upload.single("image"), createReport);
router.get("/", protect, getAllReports);
router.get("/my", protect, getMyReports);
router.put("/:id", protect, updateReportStatus);

router.delete("/:id", protect, deleteReport)

router.get("/all", viewReports);

router.put("/update-status/:id", updateReportStatus);

module.exports = router;
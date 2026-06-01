const express = require("express");

const router = express.Router();
const User = require("../models/User");
const Report = require("../models/Report");

router.get("/dashboard", async (req, res) => {

  try {

    const totalUsers =
      await User.countDocuments();

    const totalReports =
      await Report.countDocuments();

    const pendingReports =
      await Report.countDocuments({
        status: "Pending",
      });

    const investigatingReports =
      await Report.countDocuments({
        status: "Investigating",
      });

    const resolvedReports =
      await Report.countDocuments({
        status: "Resolved",
      });

    res.json({

      totalUsers,

      totalReports,

      pendingReports,

      investigatingReports,

      resolvedReports,
    });

  } catch (error) {
    console.log(error)

    res.status(500).json({
      message: error.message,
    });
  }
});

router.get("/users", async (req, res) => {
  try {

    const users = await User.find({role:"user"})
      .select("-password")
      .sort({ createdAt: -1 });

    res.json(users);

  } catch (error) {

    res.status(500).json({
      message: error.message,
    });
  }
});

router.delete("/users/:id", async (req, res) => {

  try {

    await User.findByIdAndDelete(
      req.params.id
    );

    res.json({
      message: "User deleted",
    });

  } catch (error) {

    res.status(500).json({
      message: error.message,
    });
  }
});

router.get("/analytics", async (req, res) => {
  try {

    const statusStats = await Report.aggregate([
      {
        $group: {
          _id: "$status",
          count: { $sum: 1 }
        }
      }
    ]);

    const locationStats = await Report.aggregate([
      {
        $group: {
          _id: "$location.address",
          count: { $sum: 1 }
        }
      }
    ]);

    const monthlyStats = await Report.aggregate([
      {
        $group: {
          _id: {
            month: { $month: "$createdAt" },
            year: { $year: "$createdAt" }
          },
          count: { $sum: 1 }
        }
      },
      {
        $sort: {
          "_id.year": 1,
          "_id.month": 1
        }
      }
    ]);

    res.json({
      statusStats,
      locationStats,
      monthlyStats,
    });

  } catch (error) {

    res.status(500).json({
      message: error.message,
    });
  }
});

module.exports = router;
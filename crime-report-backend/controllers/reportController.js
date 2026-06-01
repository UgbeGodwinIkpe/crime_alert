const Report = require("../models/Report");

// 🔹 CREATE REPORT
exports.createReport = async (req, res) => {
  try {
    const { title, description, nearPoliceStation, address, latitude, longitude } = req.body;

    const report = new Report({
      user: req.user._id,
      title,
      description,
      nearPoliceStation,
      image: req.file ? req.file.path : null,
      location: {
        address,
        latitude,
        longitude,
      },
    });

    await report.save();

    res.status(201).json({
      message: "Report created successfully",
      report,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 🔹 GET ALL REPORTS (ADMIN)
exports.getAllReports = async (req, res) => {
  try {
    const reports = await Report.find().populate("user", "name email phone").sort({ createdAt: -1 });

    res.json(reports);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 🔹 GET MY REPORTS
exports.getMyReports = async (req, res) => {
  try {
    const reports = await Report.find({ user: req.user._id });

    res.json(reports);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 🔹 UPDATE STATUS (ADMIN)
exports.updateReportStatus = async (req, res) => {
  try {
    const { status } = req.body;

    const report = await Report.findById(req.params.id);

    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    report.status = status || report.status;

    await report.save();

    res.json({
      message: "Report updated",
      report,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 🔴 DELETE REPORT (ONLY OWNER CAN DELETE)
exports.deleteReport = async (req, res) => {
  try {
    const report = await Report.findById(req.params.id);

    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    // ✅ Check if the logged-in user owns this report
    if (report.user.toString() !== req.user._id.toString()) {
      return res.status(401).json({ message: "Not authorized" });
    }

    await report.deleteOne();

    res.json({ message: "Report withdrawn successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.viewReports= async (req, res) => {
  try {
    // console.log("All reports");
    const reports = await Report.find().populate(
      "user",
      "name email"
    ).sort({ createdAt: -1 });
    // console.log(reports)
    res.status(200).json(reports);

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

exports.adminUpdateStatus=async (req, res) => {

    try {

      const report =
          await CrimeReport.findByIdAndUpdate(

        req.params.id,

        {
          status: req.body.status,
        },

        { new: true }
      );

      res.json(report);

    } catch (error) {

      res.status(500).json({
        message: error.message,
      });
    }
}
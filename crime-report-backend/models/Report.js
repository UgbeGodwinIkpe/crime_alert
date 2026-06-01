const mongoose = require("mongoose");

const reportSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "CUser",
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    nearPoliceStation:{
        type:String
    },
    image: {
      type: String, // path to uploaded image
    },
    location: {
      address: String,
      latitude: Number,
      longitude: Number,
    },
    status: {
      type: String,
      enum: ["Pending", "Investigating", "Resolved", "Rejected"],
      default: "Pending",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Report", reportSchema);
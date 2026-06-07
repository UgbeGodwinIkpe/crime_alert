const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// 🔹 REGISTER
exports.registerUser = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: "User already exists" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      name,
      email,
      role,
      password: hashedPassword,
    });

    res.status(201).json({
      message: "User registered successfully",
      token: generateToken(user._id),
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    console.log(error)
    res.status(500).json({ message: error.message });
  }
};

// 🔹 LOGIN
exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (user && (await bcrypt.compare(password, user.password))) {
      res.json({
        message: "Login successful",
        token: generateToken(user._id),
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
           role: user.role,
        },
      });
    } else {
      res.status(401).json({ message: "Invalid email or password" });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// 🔹 GENERATE TOKEN
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: "7d",
  });
};

exports.getUser = async (req, res) => {
  try {

    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        message: "User not found",
      });
    }

    res.json({
      name: user.name,
      email: user.email,
      phone: user.phone,
    });

  } catch (error) {

    res.status(500).json({
      error: error.message,
    });
  }
};

exports.updateUser = async (req, res) => {
  try {

    const updatedUser =await User.findByIdAndUpdate(req.params.id,
      {
        name: req.body.name,
        email: req.body.email,
        phone: req.body.phone,
      },

      { new: true }
    );

    res.json(updatedUser);

  } catch (error) {

    res.status(500).json({
      error: error.message,
    });
  }
};

exports.chnagePassword = async (req, res) => {
  try {

      const user =
          await User.findById(req.params.id);

      if (!user) {

        return res.status(404).json({
          message: "User not found",
        });
      }

      // CHECK OLD PASSWORD
      const isMatch =
          await bcrypt.compare(

        req.body.oldPassword,
        user.password
      );

      if (!isMatch) {

        return res.status(400).json({
          message: "Old password is incorrect",
        });
      }

      // HASH NEW PASSWORD
      const hashedPassword =
          await bcrypt.hash(
        req.body.newPassword,
        10
      );

      user.password = hashedPassword;

      await user.save();

      res.json({
        message:
            "Password updated successfully",
      });

    } catch (error) {

      res.status(500).json({
        error: error.message,
      });
    }
};
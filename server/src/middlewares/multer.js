// Packages
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");

//config
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (!fs.existsSync(path.join(__dirname, "../../uploads"))) {
      execSync(`mkdir "${path.join(__dirname, "../../uploads")}"`);
    }
    cb(null, "uploads");
  },
  filename: function (req, file, cb) {
    var ext = path.extname(file.originalname);
    if (
      ext !== ".jpg" &&
      ext !== ".jpeg" &&
      ext !== ".png" &&
      ext !== ".gif" &&
      ext !== ".webp"
    ) {
      var error = new Error("Only images are allowed");
      error.status = 415; // Set the status code to 415
      return cb(error);
    }
    cb(
      null,
      file.fieldname + "-" + Date.now() + path.extname(file.originalname)
    );
  },
});

/* ---------------------------------- CONST --------------------------------- */
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 10, // 10 MB
  },
});

const fileUpload = upload.fields([
  { name: "photo", maxCount: 1 },
  { name: "gallery", maxCount: 5 },
]);

// Multer config
module.exports = { fileUpload };

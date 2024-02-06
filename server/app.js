/* -------------------------------------------------------------------------- */
/*                                Dependencies                                */
/* -------------------------------------------------------------------------- */

// Packages
const express = require("express");
const dotenv = require("dotenv");
const bodyParser = require("body-parser");
var cors = require("cors");
const path = require("path");

// config
dotenv.config();

// const
const app = express();

// Connect to the database and synchronise models
const { sequelize } = require("./db.config");

sequelize
  .sync({ alter: true })
  .then(() => {
    console.log("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.text({ type: "application/xml" }));
app.use(express.static(path.join(__dirname, "public")));
// API for uploads file (photo, galleries)
app.get("/public/properties/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./public/properties/${req.params.id}`));
});

app.use(cors());

// API for uploads file (photo, galleries)
app.get("/uploads/:id", (req, res) => {
  res.sendFile(path.join(__dirname, `./uploads/${req.params.id}`));
});

// API for swagger documentation
//app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

module.exports = app;

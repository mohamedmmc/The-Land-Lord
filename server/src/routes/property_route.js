module.exports = (app) => {
  const propertyController = require("../controllers/property_controller");

  var router = require("express").Router();

  // insert elements in the database
  router.get("/", propertyController.getAvailable);
  router.get("/:id", propertyController.getDetail);

  app.use("/api/property", router);
};

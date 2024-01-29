module.exports = (app) => {
  const locationController = require("../controllers/location_controller");

  var router = require("express").Router();

  // insert elements in the database
  router.get("/", locationController.getByAvailableProperty);

  app.use("/api/location", router);
};

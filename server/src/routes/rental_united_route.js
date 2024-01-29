module.exports = (app) => {
  const userController = require("../controllers/rental_united_controller");

  var router = require("express").Router();

  // get all c²haracters
  router.get("/", userController.getAll);
  router.get("/locations", userController.location);
  router.get("/property_type", userController.propertyType);

  app.use("/api/tll", router);
};

module.exports = (app) => {
  const RentalUnitedController = require("../controllers/rental_united_controller");

  var router = require("express").Router();

  // get all c²haracters
  router.get("/", RentalUnitedController.getAll);
  router.get("/locations", RentalUnitedController.location);
  router.get("/property_type", RentalUnitedController.propertyType);
  router.get("/reservation", RentalUnitedController.getReservations);

  app.use("/api/tll", router);
};

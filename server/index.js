/* -------------------------------------------------------------------------- */
/*                                Dependencies                                */
/* -------------------------------------------------------------------------- */

// Packages
const app = require("./app");

//Importing Routes
require("./src/routes/rental_united_route")(app);
require("./src/routes/database_route")(app);
require("./src/routes/location_route")(app);
require("./src/routes/property_route")(app);

// PORT
const PORT = process.env.PORT || 3000;

app.listen(PORT, (err) => {
  if (err) {
    console.log(err);
  } else {
    console.log(`Listening on PORT ${PORT}`);
  }
});

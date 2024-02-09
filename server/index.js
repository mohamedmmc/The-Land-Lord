/* -------------------------------------------------------------------------- */
/*                                Dependencies                                */
/* -------------------------------------------------------------------------- */

// Packages
const app = require("./app");
var cors_proxy = require("cors-anywhere");

//Importing Routes
require("./src/routes/rental_united_route")(app);
require("./src/routes/database_route")(app);
require("./src/routes/location_route")(app);
require("./src/routes/property_route")(app);

var host = "0.0.0.0";
// Listen on a specific port via the PORT environment variable
var port = process.env.PORT || 8080;

cors_proxy
  .createServer({
    originWhitelist: [], // Allow all origins
    removeHeaders: ["cookie", "cookie2"],
  })
  .listen(port, host, function () {
    console.log("Running CORS Anywhere on " + host + ":" + port);
  });
// PORT
const PORT = process.env.PORT || 3000;
//
app.listen(PORT, (err) => {
  if (err) {
    console.log(err);
  } else {
    console.log(`Listening on PORT ${PORT}`);
  }
});

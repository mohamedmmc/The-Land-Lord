const axios = require("axios");
const {
  convertJsonToXml,
  addAuthentication,
  convertXmlToJson,
  getDetailedProperties,
  getDate,
  getRentalsResponse,
} = require("../helper/helpers");
const { sequelize } = require("../../db.config");

const { Property } = require("../models/property_model");
const { PropertyAmenity } = require("../models/property_amenity_model");
const { PropertyRoom } = require("../models/property_room_model");
const { PropertyImage } = require("../models/property_image_model");
const { PropertyPaiement } = require("../models/property_paiement_model");
const { Description } = require("../models/description_model");
const { Reservation } = require("../models/reservation_model");
const { PropertyPrice } = require("../models/property_price_model");
exports.getAll = async (req, res) => {
  var adresse;
  const body = {
    Pull_ListProp_RQ: {
      Authentication: {
        UserName: process.env.RENTALS_UNITED_LOGIN,
        Password: process.env.RENTALS_UNITED_PASS,
      },
    },
  };
  if (!body) {
    return res.status(400).send("missing_argument");
  }

  try {
    const propertyListJson = await getRentalsResponse(body, "Pull_ListProp_RQ");

    const propertiesList =
      propertyListJson.Pull_ListProp_RS.Properties[0].Property.map(
        (property) => ({
          id: property.ID[0]["_"],
          name: property.Name[0],
        })
      );
    // const a = await getDetailedProperties(propertiesList);
    // return res.status(200).json({ a });
    const {
      listDetailProperties,
      listPropAmenity,
      listRoomProp,
      listImageProperty,
      listPaiementProperty,
      listDescriptionProperty,
      listPriceProperty,
    } = await getDetailedProperties(propertiesList);

    const createdProperties = [];

    //list detail properties
    await Property.destroy({ where: {} });
    for (const [index, property] of listDetailProperties.entries()) {
      // adresse = property[index].id;
      await Property.bulkCreate(property);
      createdProperties.push(property);
    }

    await PropertyPrice.destroy({ where: {} });
    for (const price of listPriceProperty) {
      // adresse = propAme;
      await PropertyPrice.bulkCreate(price);
    }
    await PropertyAmenity.destroy({ where: {} });
    // list association property amenities
    for (const propAme of listPropAmenity) {
      // adresse = propAme;
      await PropertyAmenity.bulkCreate(propAme);
    }
    await PropertyRoom.destroy({ where: {} });
    // list association property room
    for (const propRoom of listRoomProp) {
      await PropertyRoom.bulkCreate(propRoom);
    }

    await PropertyImage.destroy({ where: {} });
    // list association property image
    for (const imageProp of listImageProperty) {
      listImageProperty[42];
      if (imageProp !== null) {
        // Check for null
        await PropertyImage.bulkCreate(imageProp);
      } else {
        // Handle null imageProp, e.g., log a warning or take other actions
        console.warn("Skipping null image property.");
      }
    }

    await PropertyPaiement.destroy({ where: {} });
    // list association property image
    for (const payement of listPaiementProperty) {
      await PropertyPaiement.bulkCreate(payement);
    }

    await Description.destroy({ where: {} });
    // list association property image
    for (const description of listDescriptionProperty) {
      await Description.bulkCreate(description);
    }
    const listReservations = await getAllReservation();
    await Reservation.destroy({ where: {} });
    for (const reservation of listReservations) {
      const foundedProperty = await Property.findOne({
        where: { id: reservation.property_id },
      });
      if (foundedProperty) {
        Reservation.create(reservation).catch((error) => {
          console.error("Error fetching data:", error);
        });
      }
    }
    return res.status(200).json(
      createdProperties
      // test.detailedProperties[0]
      // test.detailedProperties[0].Pull_ListSpecProp_RS.Property
    );
  } catch (error) {
    // console.log(error);
    return res.status(500).json({ error });
  }
};
exports.location = async (req, res) => {
  try {
    const body = {
      Pull_ListLocations_RQ: {},
    };
    const xmlData = convertJsonToXml(
      addAuthentication(body, "Pull_ListLocations_RQ")
    );

    const apiResponse = await axios.post(
      process.env.RENTALS_UNITED_LINK,
      xmlData,
      {
        headers: {
          "Content-Type": "text/xml",
        },
      }
    );
    var convertedDetailPropertyList = [];
    const propertyListJson = await convertXmlToJson(apiResponse.data);
    for (const detailedProperty of propertyListJson.Pull_ListLocations_RS
      .Locations[0].Location) {
      const name = detailedProperty._;
      const ids = detailedProperty.$;

      const newObject = {
        name: name,
        locationID: ids.LocationID,
        locationTypeID: ids.LocationTypeID,
        parentLocationID: ids.ParentLocationID,
        timezone: ids.TimeZone,
      };

      if (
        newObject.parentLocationID == 9502 ||
        newObject.parentLocationID == 10996 ||
        newObject.parentLocationID == 10351 ||
        newObject.parentLocationID == 10342 ||
        newObject.parentLocationID == 20
      )
        convertedDetailPropertyList.push(newObject);
    }
    return res.status(200).json({ convertedDetailPropertyList });
  } catch (error) {
    return res.status(500).json({ error });
  }
};

exports.propertyType = async (req, res) => {
  try {
    const body = {
      Pull_ListPropTypes_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
      },
    };
    const propertyListJson = await getRentalsResponse(
      body,
      "Pull_ListPropTypes_RQ"
    );

    var listPropertyType = [];
    for (const detailedProperty of propertyListJson.Pull_ListPropTypes_RS
      .PropertyTypes[0].PropertyType) {
      const name = detailedProperty._;
      const ids = detailedProperty.$;

      const newObject = {
        name: name,
        locationID: ids.PropertyTypeID,
      };
      listPropertyType.push(newObject);
    }
    return res.status(200).json({ listPropertyType });
  } catch (error) {
    return res.status(500).json({ error });
  }
};

exports.getReservations = async (req, res) => {
  try {
    const reservations = await getAllReservation();
    await Reservation.destroy({ where: {} });
    for (const reservation of reservations) {
      const foundedProperty = await Property.findOne({
        where: { id: reservation.property_id },
      });
      if (foundedProperty) {
        Reservation.create(reservation).catch((error) => {
          console.error("Error fetching data:", error);
        });
      }
    }
    return res.status(200).json(reservations);
  } catch (error) {
    return res.status(500).json({ error });
  }
};

async function getAllReservation() {
  var listReservations = [];
  const oneYearLaterFormatted = getDate(1, "years");
  const nowFormatted = getDate(0, "years");
  const query = `
    SELECT location.id ,location.name, COUNT(location.name) as count FROM location
    JOIN property on location.id = property.location_id
    WHERE property.is_active = 'true'
    GROUP by location.name
  `;
  const locationList = await sequelize.query(query, {
    type: sequelize.QueryTypes.SELECT,
  });
  let index = 0;
  for (const location of locationList) {
    const body = {
      Pull_ListPropertiesBlocks_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        LocationID: location.id,
        DateFrom: nowFormatted,
        DateTo: oneYearLaterFormatted,
      },
    };
    const propertyListJson = await getRentalsResponse(
      body,
      "Pull_ListPropertiesBlocks_RQ"
    );

    if (propertyListJson.Pull_ListPropertiesBlocks_RS.Properties[0] !== "")
      for (const propertyReservation of propertyListJson
        .Pull_ListPropertiesBlocks_RS.Properties?.[0]?.PropertyBlock) {
        for (const dates of propertyReservation.Block) {
          if (propertyReservation["$"].PropertyID == 3754945) {
            console.log("youpi");
          }
          const reservation = {
            property_id: propertyReservation["$"].PropertyID,
            date_from: dates.DateFrom[0],
            date_to: dates.DateTo[0],
          };
          listReservations.push(reservation);
        }
      }
    index++;
    console.log(`${index} of ${locationList.length}`);
  }

  return listReservations;
}

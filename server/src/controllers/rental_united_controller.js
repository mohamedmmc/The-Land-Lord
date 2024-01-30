const axios = require("axios");
const {
  convertJsonToXml,
  addAuthentication,
  convertXmlToJson,
  getDetailedProperties,
} = require("../helper/helpers");
const { sequelize } = require("../../db.config");

const { Property } = require("../models/property_model");
const { PropertyAmenity } = require("../models/property_amenity_model");
const { PropertyRoom } = require("../models/property_room_model");
const { PropertyImage } = require("../models/property_image_model");
const { PropertyPaiement } = require("../models/property_paiement_model");
const { Description } = require("../models/description_model");
exports.getAll = async (req, res) => {
  var adresse;
  const body = {
    Pull_ListProp_RQ: {},
  };
  if (!body) {
    return res.status(400).send("missing_argument");
  }

  try {
    const xmlData = convertJsonToXml(
      addAuthentication(body, "Pull_ListProp_RQ")
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
    const propertyListJson = await convertXmlToJson(apiResponse.data);
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
    } = await getDetailedProperties(propertiesList);

    const createdProperties = [];

    //list detail properties
    await Property.destroy({ where: {} });
    for (const [index, property] of listDetailProperties.entries()) {
      // adresse = property[index].id;
      await Property.bulkCreate(property, {
        updateOnDuplicate: ["name"],
        updateOnDuplicate: ["last_modified"],
        updateOnDuplicate: ["street"],
        updateOnDuplicate: ["date_created"],
        updateOnDuplicate: ["cleaning_price"],
        updateOnDuplicate: ["space"],
        updateOnDuplicate: ["standard_guests"],
        updateOnDuplicate: ["can_sleep_max"],
        updateOnDuplicate: ["zip_code"],
        updateOnDuplicate: ["floor"],
        updateOnDuplicate: ["preparation_time_before_arrival"],
        updateOnDuplicate: ["napreparation_time_before_arrival_in_hoursme"],
        updateOnDuplicate: ["is_active"],
        updateOnDuplicate: ["is_archived"],
        updateOnDuplicate: ["location_id"],
        updateOnDuplicate: ["coordinates"],
        updateOnDuplicate: ["arrival_instructions"],
        updateOnDuplicate: ["check_in_out"],
        updateOnDuplicate: ["deposit_id"],
        updateOnDuplicate: ["deposit_value"],
        updateOnDuplicate: ["cancellation_policies"],
        updateOnDuplicate: ["type_property_id"],
      });
      createdProperties.push(property);
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
      await PropertyImage.bulkCreate(imageProp);
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
    return res.status(200).json(
      createdProperties
      // test.detailedProperties[0]
      // test.detailedProperties[0].Pull_ListSpecProp_RS.Property
    );
  } catch (error) {
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
      Pull_ListPropTypes_RQ: {},
    };
    const xmlData = convertJsonToXml(
      addAuthentication(body, "Pull_ListPropTypes_RQ")
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
    var listPropertyType = [];
    const propertyListJson = await convertXmlToJson(apiResponse.data);
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
    const timestamp = Date.now(); // Get the current timestamp in milliseconds
    const date = new Date(timestamp); // Create a new Date object from the timestamp
    const formattedDate = date.toISOString().slice(0, 10);
    const body = {
      Pull_ListPropertiesBlocks_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        // PropertyID: 2698982,
        LocationId: 63298,
        DateFrom: formattedDate,
        DateTo: "2024-03-02",
      },
    };
    const xmlData = convertJsonToXml(body);

    const apiResponse = await axios.post(
      process.env.RENTALS_UNITED_LINK,
      xmlData,
      {
        headers: {
          "Content-Type": "text/xml",
        },
      }
    );
    var listPropertyType = [];
    const propertyListJson = await convertXmlToJson(apiResponse.data);
    // for (const detailedProperty of propertyListJson.Pull_ListPropTypes_RS
    //   .PropertyTypes[0].PropertyType) {
    //   const name = detailedProperty._;
    //   const ids = detailedProperty.$;

    //   const newObject = {
    //     name: name,
    //     locationID: ids.PropertyTypeID,
    //   };
    //   listPropertyType.push(newObject);
    // }
    return res.status(200).json({ propertyListJson });
  } catch (error) {
    return res.status(500).json({ error });
  }
};

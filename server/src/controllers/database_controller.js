const { Amenity } = require("../models/amenity_model");
const { Location } = require("../models/location_model");
const { PropertyRoomType } = require("../models/type_property_room_model");
const { PropertyType } = require("../models/type_property_model");
const { RoomType } = require("../models/type_room_model");
const { DepositType } = require("../models/type_deposit_model");
const { PayementType } = require("../models/type_payement_model");
const { LanguageType } = require("../models/type_language_model");
const { Property } = require("../models/property_model");
const { constantId } = require("../helper/constants");
const { sequelize } = require("../../db.config");

// insert elements in the database
exports.insert = async (req, res) => {
  try {
    const amenities = constantId.Amenity;
    const locations = constantId.Locations;
    const rooms = constantId.RoomsType;
    const propertyRoomType = constantId.PropertyRoomType;
    const propertyType = constantId.PropertyType;
    const depositType = constantId.DepositType;
    const paymentType = constantId.PaymentType;
    const languageType = constantId.LanguageType;
    // const properties = constantId.Properties;

    const createdAmenities = await Amenity.bulkCreate(amenities);
    const createdLocations = await Location.bulkCreate(locations);
    const createdPropertyRoomTypes = await PropertyRoomType.bulkCreate(
      propertyRoomType
    );
    const createdPropertyType = await PropertyType.bulkCreate(propertyType);
    const createdRooms = await RoomType.bulkCreate(rooms);
    const createdDepositType = await DepositType.bulkCreate(depositType);
    const createdPayementType = await PayementType.bulkCreate(paymentType);
    const createdLanguageType = await LanguageType.bulkCreate(languageType);
    // const createdProperty = await Property.bulkCreate(properties);

    const result = {
      createdAmenities,
      createdLocations,
      createdPropertyRoomTypes,
      createdRooms,
      createdDepositType,
      createdPayementType,
      createdLanguageType,
      createdPropertyType,
      // createdProperty,
    };

    return res.status(200).json(result);
  } catch (error) {
    return res.status(500).json({ error });
  }
};

// reset the database
exports.reset = async (req, res) => {
  try {
    await sequelize.sync({ force: true });
    res.json({ message: "Database reset successful" });
  } catch (error) {
    res.status(500).json({ error: "Failed to reset database" });
  }
};

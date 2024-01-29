const { sequelize, Sequelize } = require("../../db.config");
const { Amenity } = require("../models/amenity_model");
const { Property } = require("../models/property_model");
const PropertyAmenity = sequelize.define(
  "property_amenity",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    count: { type: Sequelize.INTEGER, allowNull: false },
  },
  {
    tableName: "property_amenity",
    timestamps: false,
  }
);

PropertyAmenity.belongsTo(Property, { foreignKey: "property_id" });
PropertyAmenity.belongsTo(Amenity, { foreignKey: "amenity_id" });
module.exports = {
  PropertyAmenity,
};

const { sequelize, Sequelize } = require("../../db.config");
const { Property } = require("../models/property_model");
const PropertyPrice = sequelize.define(
  "property_price",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    price: { type: Sequelize.STRING },
    date_from: { type: Sequelize.STRING },
    date_to: { type: Sequelize.STRING },
  },
  {
    tableName: "property_price",
    timestamps: false,
  }
);

PropertyPrice.belongsTo(Property, { foreignKey: "property_id" });

module.exports = {
  PropertyPrice,
};

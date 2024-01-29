const { sequelize, Sequelize } = require("../../db.config");
const { Property } = require("./property_model");
const PropertyImage = sequelize.define(
  "property_image",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    url: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "property_image",
    timestamps: false,
  }
);

PropertyImage.belongsTo(Property, { foreignKey: "property_id" });
module.exports = {
  PropertyImage,
};

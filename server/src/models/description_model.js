const { sequelize, Sequelize } = require("../../db.config");
const { Property } = require("../models/property_model");
const { LanguageType } = require("../models/type_language_model");
const Description = sequelize.define(
  "description",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    text: { type: Sequelize.TEXT },
    house_rules: { type: Sequelize.TEXT },
  },
  {
    tableName: "description",
    timestamps: false,
  }
);
Description.belongsTo(Property, { foreignKey: "property_id" });
Description.belongsTo(LanguageType, { foreignKey: "language_id" });

module.exports = {
  Description,
};

const { sequelize, Sequelize } = require("../../db.config");
const PropertyType = sequelize.define(
  "type_property",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
    OTACode: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "type_property",
    timestamps: false,
  }
);
module.exports = {
  PropertyType,
};

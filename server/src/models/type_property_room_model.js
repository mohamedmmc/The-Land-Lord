const { sequelize, Sequelize } = require("../../db.config");
const PropertyRoomType = sequelize.define(
  "type_property_room",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "type_property_room",
    timestamps: false,
  }
);
module.exports = {
  PropertyRoomType,
};

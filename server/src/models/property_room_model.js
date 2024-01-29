const { sequelize, Sequelize } = require("../../db.config");
const { RoomType } = require("./type_room_model");
const { Property } = require("./property_model");
const PropertyRoom = sequelize.define(
  "property_room",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
  },
  {
    tableName: "property_room",
    timestamps: false,
  }
);

PropertyRoom.belongsTo(Property, { foreignKey: "property_id" });
PropertyRoom.belongsTo(RoomType, { foreignKey: "room_id" });
module.exports = {
  PropertyRoom,
};

const { sequelize, Sequelize } = require("../../db.config");
const RoomType = sequelize.define(
  "type_room",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "type_room",
    timestamps: false,
  }
);
module.exports = {
  RoomType,
};

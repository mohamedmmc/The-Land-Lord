const { sequelize, Sequelize } = require("../../db.config");
const Amenity = sequelize.define(
  "amenity",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true },
    name: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "amenity",
    timestamps: false,
  }
);
module.exports = {
  Amenity,
};

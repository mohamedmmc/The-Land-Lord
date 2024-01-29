const { sequelize, Sequelize } = require("../../db.config");
const Location = sequelize.define(
  "location",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    locationTypeID: { type: Sequelize.INTEGER },
    parentLocationID: { type: Sequelize.INTEGER },
    name: { type: Sequelize.STRING, allowNull: false },
    timezone: { type: Sequelize.STRING },
  },
  {
    tableName: "location",
    timestamps: false,
  }
);

module.exports = {
  Location,
};

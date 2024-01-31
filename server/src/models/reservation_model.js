const { sequelize, Sequelize } = require("../../db.config");
const { Property } = require("./property_model");
const Reservation = sequelize.define(
  "reservation",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    date_from: { type: Sequelize.STRING, allowNull: false },
    date_to: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "reservation",
    timestamps: false,
  }
);

Reservation.belongsTo(Property, { foreignKey: "property_id" });
module.exports = {
  Reservation,
};

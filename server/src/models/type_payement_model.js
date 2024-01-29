const { sequelize, Sequelize } = require("../../db.config");
const PayementType = sequelize.define(
  "type_payement",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
    name: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "type_payement",
    timestamps: false,
  }
);
module.exports = {
  PayementType,
};

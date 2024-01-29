const { sequelize, Sequelize } = require("../../db.config");
const DepositType = sequelize.define(
  "type_deposit",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true },
    name: { type: Sequelize.STRING, allowNull: false },
  },
  {
    tableName: "type_deposit",
    timestamps: false,
  }
);
module.exports = {
  DepositType,
};

const { sequelize, Sequelize } = require("../../db.config");
const { Property } = require("./property_model");
const { PayementType } = require("./type_payement_model");
const PropertyPaiement = sequelize.define(
  "property_paiement",
  {
    id: { type: Sequelize.INTEGER, primaryKey: true, autoIncrement: true },
  },
  {
    tableName: "property_paiement",
    timestamps: false,
  }
);

PropertyPaiement.belongsTo(Property, { foreignKey: "property_id" });
PropertyPaiement.belongsTo(PayementType, { foreignKey: "payement_id" });
module.exports = {
  PropertyPaiement,
};

const { sequelize, Sequelize } = require("../../db.config");
const { Location } = require("../models/location_model");
const { DepositType } = require("./type_deposit_model");
const { PropertyType } = require("./type_property_model");
const Property = sequelize.define(
  "property",
  {
    id: { type: Sequelize.STRING, primaryKey: true },
    name: { type: Sequelize.STRING, allowNull: false },
    last_modified: { type: Sequelize.STRING },
    street: { type: Sequelize.STRING },
    date_created: { type: Sequelize.STRING },
    cleaning_price: { type: Sequelize.STRING },
    space: { type: Sequelize.STRING },
    standard_guests: { type: Sequelize.STRING },
    can_sleep_max: { type: Sequelize.STRING },
    zip_code: { type: Sequelize.STRING },
    floor: { type: Sequelize.STRING },
    preparation_time_before_arrival: { type: Sequelize.STRING },
    preparation_time_before_arrival_in_hours: { type: Sequelize.STRING },
    is_active: { type: Sequelize.STRING },
    is_archived: { type: Sequelize.STRING },
    // terms_and_conditions_links: { type: Sequelize.STRING },
    coordinates: { type: Sequelize.JSON },
    arrival_instructions: { type: Sequelize.JSON },
    cancellation_policies: { type: Sequelize.JSON },
    check_in_out: { type: Sequelize.JSON },
    deposit_value: { type: Sequelize.STRING },
    type_property_id: { type: Sequelize.STRING },
  },
  {
    tableName: "property",
    timestamps: false,
  }
);

Property.belongsTo(Location, { foreignKey: "location_id" });
Property.belongsTo(DepositType, { foreignKey: "deposit_id" });

module.exports = {
  Property,
};

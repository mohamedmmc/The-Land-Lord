const { sequelize } = require("../../db.config");
const { listAmenities, locationGroup } = require("../helper/constants");
// get all regions by available properties
exports.getByAvailableProperty = async (req, res) => {
  try {
    const queryLocation = `
    SELECT location.id, location.name
    FROM location
    JOIN property ON location.id = property.location_id
    WHERE property.is_active = 'true'
      AND location.id NOT IN (63298, 63299)
    GROUP BY location.id, location.name;
  `;
    const locationList = await sequelize.query(queryLocation, {
      type: sequelize.QueryTypes.SELECT,
    });

    const queryPropertyType = `
    select type_property.id, type_property.name,  COUNT(type_property.name) as count 
    from property
    JOIN type_property on property.type_property_id = type_property.id
    GROUP by property.type_property_id
  `;
    const propertyTypelist = await sequelize.query(queryPropertyType, {
      type: sequelize.QueryTypes.SELECT,
    });

    return res
      .status(200)
      .json({ locationList, propertyTypelist, listAmenities });
  } catch (error) {
    return res.status(500).json({ message: "error" });
  }
};

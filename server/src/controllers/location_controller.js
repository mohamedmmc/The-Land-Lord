const { sequelize } = require("../../db.config");

// get all regions by available properties
exports.getByAvailableProperty = async (req, res) => {
  try {
    const query = `
    SELECT location.id ,location.name, COUNT(location.name) as count FROM location
    JOIN property on location.id = property.location_id
    WHERE property.is_active = 'true'
    GROUP by location.name
  `;
    const locationList = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
    });
    return res.status(200).json(locationList);
  } catch (error) {
    return res.status(500).json({ message: "error" });
  }
};

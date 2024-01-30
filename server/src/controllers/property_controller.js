const { sequelize } = require("../../db.config");

// get all regions by available properties
exports.getAvailable = async (req, res) => {
  const {
    location,
    languageQuery,
    priceMin,
    priceMax,
    pageQuery,
    limitQuery,
    guest,
    room,
    petAllowed,
    smokeAllowed,
  } = req.query;
  const language = languageQuery ? languageQuery : 1;
  const page = pageQuery ?? 1;
  const limit = limitQuery ? parseInt(limitQuery) : 8;
  const offset = (page - 1) * limit;
  try {
    const query = `
    SELECT
      property.id,
      property.name as name,
      SUBSTRING_INDEX(GROUP_CONCAT(property_image.url ORDER BY property_image.url ASC SEPARATOR ','), ',', 3) AS image_urls,
      location.name as location,
      description.house_rules,
      description.text,
      property.can_sleep_max,
      property.standard_guests
    FROM property
    JOIN property_image ON property.id = property_image.property_id
    JOIN location ON property.location_id = location.id
    JOIN description on property.id = description.property_id
    WHERE property.is_active = 'true'
      ${
        petAllowed !== undefined
          ? "AND description.house_rules LIKE :petAllowed"
          : ""
      }
      ${
        smokeAllowed !== undefined
          ? "AND description.house_rules LIKE :smokeAllowed"
          : ""
      }
      ${isNaN(location) ? "" : "AND property.location_id = :location"}
      ${isNaN(guest) ? "" : "AND property.standard_guests <= :guest"}
      ${isNaN(room) ? "" : "AND property.can_sleep_max <= :room"}
    GROUP BY property.id, property.name, location.name

    `;

    const locationList = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        location: location,
        guest: guest,
        room: room,
        offset: offset,
        limit: limit,
        petAllowed: `%Pets - ${petAllowed}%`,
        smokeAllowed: `%Smoking - ${smokeAllowed}%`,
      },
    });

    const formattedList = locationList.map((row) => ({
      id: row.id,
      name: row.name,
      location: row.location,
      images: row.image_urls.split(","),
      houseRules: row.house_rules,
      description: row.text,
      rooms: row.can_sleep_max,
      guests: row.standard_guests,
    }));
    return res.status(200).json({ formattedList });
  } catch (error) {
    return res.status(500).json({ message: "error" });
  }
};

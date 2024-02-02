const { sequelize } = require("../../db.config");
const { getDate } = require("../helper/helpers");
// get all regions by available properties
exports.getAvailable = async (req, res) => {
  const {
    location,
    languageQuery,
    priceMin,
    priceMax,
    dateFrom,
    dateTo,
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
        property.name AS name,
        SUBSTRING_INDEX(GROUP_CONCAT(property_image.url ORDER BY property_image.url ASC SEPARATOR ','), ',', 3) AS image_urls,
        description.house_rules,
        description.text,
        property.can_sleep_max,
        property.standard_guests,
        location.id AS location,
        property.coordinates,
        property_price.price 
      FROM property
      JOIN property_image ON property.id = property_image.property_id
      JOIN location ON property.location_id = location.id
      JOIN description ON property.id = description.property_id
      LEFT JOIN property_price ON property.id = property_price.property_id AND CAST(:dateFrom AS DATE) BETWEEN property_price.date_from AND property_price.date_to
      WHERE property.is_active = 'true'
      ${
        dateFrom && dateTo
          ? `AND (
          CASE WHEN :dateFrom IS NOT NULL AND :dateTo IS NULL THEN
            CAST(:dateFrom AS DATE) + INTERVAL 1 MONTH
          WHEN :dateTo IS NOT NULL AND :dateFrom IS NULL THEN
            CAST(:dateTo AS DATE) - INTERVAL 1 MONTH
          ELSE
            property.id NOT IN (
              SELECT property_id
              FROM Reservation
              WHERE (
                CAST(date_from AS DATE) BETWEEN CAST(:dateFrom AS DATE) AND CAST(:dateTo AS DATE)
                OR CAST(date_to AS DATE) BETWEEN CAST(:dateFrom AS DATE) AND CAST(:dateTo AS DATE)
                OR CAST(:dateFrom AS DATE) BETWEEN CAST(date_from AS DATE) AND CAST(date_to AS DATE)
                OR CAST(:dateTo AS DATE) BETWEEN CAST(date_from AS DATE) AND CAST(date_to AS DATE)
              )
            )
          END
        )`
          : ""
      }
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
        ${!location ? "" : "AND property.location_id = :location"}
        ${!guest ? "" : "AND property.standard_guests = :guest"}
        ${!room ? "" : "AND property.can_sleep_max = :room"}
        ${!priceMax ? "" : "AND property_price.price <= :priceMax"}
        ${!priceMin ? "" : "AND property_price.price >= :priceMin"}
      GROUP BY property.id, property.name, location.id
      LIMIT :limit OFFSET :offset;
    `;
    const locationList = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        location: location ?? parseInt,
        guest: guest ?? parseInt,
        room: room ?? parseInt,
        offset: offset,
        dateFrom: dateFrom ?? getDate(0, "years"),
        dateTo: dateTo ?? null,
        limit: limit,
        priceMax: priceMax ?? parseInt(priceMax),
        priceMin: priceMin ?? parseInt(priceMin),
        petAllowed: `%Pets - ${petAllowed}%`,
        smokeAllowed: `%Smoking - ${smokeAllowed}%`,
      },
    });

    const formattedList = locationList.map((row) => ({
      id: row.id,
      name: row.name,
      price: String(row.price * 3.1),
      location: row.location,
      coordinates: row.coordinates,
      images: row.image_urls.split(","),
      houseRules: row.house_rules,
      description: row.text,
      beds: row.can_sleep_max,
      guests: row.standard_guests,
    }));
    return res.status(200).json({ formattedList });
  } catch (error) {
    return res.status(500).json({ message: error });
  }
};

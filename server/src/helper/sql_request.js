const { sequelize } = require("../../db.config");

//function to get name and id from a given ids and table
const fetchNames = async (ids, tableName) => {
  const query = `
    SELECT id, name
    FROM ${tableName}
    WHERE id IN (:ids)
  `;
  const results = await sequelize.query(query, {
    replacements: { ids },
    type: sequelize.QueryTypes.SELECT,
  });

  const idCounts = {};
  ids.forEach((id) => {
    idCounts[id] = (idCounts[id] || 0) + 1;
  });

  return results.map((result) => ({
    id: result.id,
    name: result.name,
    count: idCounts[result.id] || 0,
  }));
};

const getImageByPropertyId = async (propertyId) => {
  const query = `
    SELECT id,url, thumbnail
    FROM property_image
    WHERE property_id = :propertyId
  `;
  const results = await sequelize.query(query, {
    replacements: { propertyId: propertyId },
    type: sequelize.QueryTypes.SELECT,
  });

  return results.map((result) => ({
    id: result.id,
    url: result.url,
    thumbnail: result.thumbnail,
  }));
};

module.exports = { fetchNames, getImageByPropertyId };

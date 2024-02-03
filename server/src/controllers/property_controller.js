const { sequelize } = require("../../db.config");
const { getDate, getRentalsResponse } = require("../helper/helpers");
// get all regions by available properties
exports.getAvailable = async (req, res) => {
  const devise = 3.1;
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
    typeProperty,
    amenities,
  } = req.query;
  const language = languageQuery ? languageQuery : 1;
  const page = pageQuery ?? 1;
  const listAmenities = amenities ? JSON.parse(amenities) : [];
  const limit = limitQuery ? parseInt(limitQuery) : 8;
  const offset = (page - 1) * limit;
  try {
    const query = `
      SELECT
        property.id,
        property.name AS name,
        property.cleaning_price,
        SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT property_image.url ORDER BY property_image.id ASC SEPARATOR ','), ',', 3) AS image_urls,
        description.house_rules,
        description.text,
        property.can_sleep_max,
        property.standard_guests,
        location.id AS location,
        property.coordinates,
        property_price.price,
        GROUP_CONCAT(property_amenity.amenity_id) AS amenity_ids
      FROM property
      JOIN property_image ON property.id = property_image.property_id
      JOIN location ON property.location_id = location.id
      JOIN description ON property.id = description.property_id
      LEFT JOIN property_price ON property.id = property_price.property_id AND CAST(:dateFrom AS DATE) BETWEEN property_price.date_from AND property_price.date_to
      LEFT JOIN property_amenity ON property.id = property_amenity.property_id
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
        ${!priceMax ? "" : "AND property_price.price * :devise <= :priceMax"}
        ${!priceMin ? "" : "AND property_price.price * :devise >= :priceMin"}
        ${!typeProperty ? "" : "AND property.type_property_id = :typeProperty"}
      GROUP BY property.id, property.name, location.id
      LIMIT :limit OFFSET :offset;
    `;
    const locationList = await sequelize.query(query, {
      type: sequelize.QueryTypes.SELECT,
      replacements: {
        location: location ? parseInt(location) : null,
        guest: guest ? parseInt(guest) : null,
        room: room ? parseInt(room) : null,
        typeProperty: typeProperty ? parseInt(typeProperty) : null,
        offset: offset,
        dateFrom: dateFrom ?? getDate(0, "years"),
        dateTo: dateTo ?? null,
        limit: limit,
        priceMax: priceMax ? parseInt(priceMax) : null,
        priceMin: priceMin ? parseInt(priceMin) : null,
        petAllowed: `%Pets - ${petAllowed}%`,
        smokeAllowed: `%Smoking - ${smokeAllowed}%`,
        devise: devise,
      },
    });

    const formattedList = locationList
      .filter(
        (row) =>
          row.price != null &&
          hasDesiredAmenities(row.amenity_ids, listAmenities)
      )
      .map((row) => ({
        id: row.id,
        name: row.name,
        price: String(
          (parseInt(row.price) + parseInt(row.cleaning_price)) * devise
        ),
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

exports.getDetail = async (req, res) => {
  const ID = req.params.id;

  var body = {
    Pull_ListSpecProp_RQ: {
      Authentication: {
        UserName: process.env.RENTALS_UNITED_LOGIN,
        Password: process.env.RENTALS_UNITED_PASS,
      },
      PropertyID: ID,
    },
  };
  try {
    var jsonResult = await getRentalsResponse(body, "Pull_ListSpecProp_RQ");

    // data of detailed property
    const mappedProperties = jsonResult.Pull_ListSpecProp_RS.Property.map(
      (property) => ({
        id: property.ID[0]["_"],
        name: property.Name[0],
        location_id: property.DetailedLocationID[0]["_"],
        last_modified: property.LastMod[0]["_"],
        date_created: property.DateCreated[0],
        cleaning_price: property.CleaningPrice[0],
        space: property.Space[0],
        standard_guests: property.StandardGuests[0],
        can_sleep_max: property.CanSleepMax[0],
        type_property_id: property.PropertyTypeID[0],
        objectType_id: property.ObjectTypeID[0],
        // noOfUnits: property.NoOfUnits[0],
        image: property.Images?.[0]?.Image?.map((image) => {
          return {
            url: image["_"],
          };
        }),
        paiement: property.PaymentMethods?.[0]?.PaymentMethod?.map(
          (paiement) => {
            return {
              payement_id: paiement["$"].PaymentMethodID,
            };
          }
        ),
        room: property.CompositionRoomsAmenities?.[0]?.CompositionRoomAmenities?.map(
          (room) => {
            return {
              room_id: room["$"].CompositionRoomID,
            };
          }
        ),
        amenities: property.Amenities?.[0]?.Amenity?.map((amenity) => {
          return {
            amenity_id: amenity["_"],
            count: amenity["$"].Count,
          };
        }),
        floor: property.Floor[0],
        street: property.Street[0],
        zip_code: property.ZipCode[0],
        coordinates: property.Coordinates[0],
        check_in_out: property.CheckInOut[0],
        deposit_id: property.Deposit[0]["$"].DepositTypeID,
        deposit_value: property.Deposit[0]["_"],
        preparation_time_before_arrival:
          property.PreparationTimeBeforeArrival[0],
        preparation_time_before_arrival_in_hours:
          property.PreparationTimeBeforeArrivalInHours[0],
        is_active: property.IsActive[0],
        is_archived: property.IsArchived[0],
        //terms_and_conditions_links: property.TermsAndConditionsLinks[0],
        cancellation_policies:
          property.CancellationPolicies[0].CancellationPolicy?.map(
            (cancellationPolicy) => {
              return {
                value: cancellationPolicy["_"],
                validFrom: cancellationPolicy["$"].ValidFrom,
                validTo: cancellationPolicy["$"].ValidTo,
              };
            }
          ),
      })
    );
    var bodyAvailibility = {
      Pull_ListPropertiesBlocks_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        LocationID: mappedProperties[0].location_id,
        DateFrom: getDate(0, "years"),
        DateTo: getDate(1, "years"),
      },
    };
    var jsonResultPrice = await getRentalsResponse(
      bodyAvailibility,
      "Pull_ListPropertiesBlocks_RQ"
    );

    return res.status(200).json({ mappedProperties, jsonResultPrice });
  } catch (error) {
    return res.status(500).json({ message: error });
  }
};
// Function to check if the property has the desired amenities
function hasDesiredAmenities(propertyAmenities, desiredAmenities) {
  if (!propertyAmenities) {
    return false;
  }
  const propertyAmenityIds = propertyAmenities.split(",").map(Number);
  return desiredAmenities.every((amenityId) =>
    propertyAmenityIds.includes(amenityId)
  );
}

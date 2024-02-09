const { sequelize } = require("../../db.config");
const { getDate, getRentalsResponse } = require("../helper/helpers");
const { fetchNames, getImageByPropertyId } = require("../helper/sql_request");
const { locationGroup } = require("../helper/constants");
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
    wcCount,
  } = req.query;
  const language = languageQuery ? languageQuery : 1;
  const page = pageQuery ?? 1;
  const listAmenities = amenities ? JSON.parse(amenities) : null;
  const limit = limitQuery ? parseInt(limitQuery) : 9;
  const offset = (page - 1) * limit;

  try {
    const isGroupMarsa = locationGroup.laMarsa.children.includes(
      parseInt(location)
    );

    const query = `
      SELECT
        property.id,
        property.name AS name,
        property.cleaning_price,
        (SELECT COUNT(*) FROM property_room WHERE room_id = 81 and property.id = property_room.property_id) AS wc_count,
        SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT property_image.thumbnail ORDER BY property_image.id ASC SEPARATOR ','), ',', 3) AS image_urls,
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
      LEFT JOIN property_price ON property.id = property_price.property_id AND CAST(:dateFrom AS DATE) >= CAST(property_price.date_from AS DATE)
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
        ${
          !location
            ? ""
            : isGroupMarsa
            ? "AND location.id IN (63298, 63299,25348)"
            : "AND property.location_id = :location"
        }
        ${
          !guest
            ? ""
            : guest == 5
            ? "AND property.standard_guests >= :guest"
            : "AND property.standard_guests = :guest"
        }
        ${
          !room
            ? ""
            : room == 5
            ? "AND property.can_sleep_max >= :room"
            : "AND property.can_sleep_max = :room"
        }
        ${!priceMax ? "" : "AND property_price.price * :devise <= :priceMax"}
        ${!priceMin ? "" : "AND property_price.price * :devise >= :priceMin"}
        
        ${!typeProperty ? "" : "AND property.type_property_id = :typeProperty"}
        ${
          !listAmenities
            ? ""
            : `AND property.id IN (
              SELECT property_id 
              FROM property_amenity 
              WHERE amenity_id IN (:listAmenities)
              )`
        }
      GROUP BY property.id, property.name, location.id
      ${!wcCount ? "" : "HAVING wc_count = :wcCount"}
      LIMIT :limit OFFSET :offset 
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
        wcCount: wcCount ? parseInt(wcCount) : null,
        listAmenities: listAmenities,
      },
    });

    const formattedList = locationList
      .filter((row) => row.price != null)
      .map((row) => ({
        id: row.id,
        name: row.name,
        price: String(
          // (parseInt(row.price) + parseInt(row.cleaning_price)) * devise
          parseInt(row.price) * devise
        ),
        location: row.location,
        coordinates: row.coordinates,
        images: row.image_urls.split(","),
        houseRules: row.house_rules,
        description: row.text,
        beds: row.can_sleep_max,
        guests: row.standard_guests,
        wcCount: row.wc_count,
      }));
    return res.status(200).json({ formattedList });
  } catch (error) {
    return res.status(500).json({ message: a });
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
    const mappedPropertiesRentals =
      jsonResult.Pull_ListSpecProp_RS.Property.map((property) => ({
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
          property.PreparationTimeBeforeArrivalInHours[0] + " H",
        is_active: property.IsActive[0],
        is_archived: property.IsArchived[0],
        houseRules:
          jsonResult.Pull_ListSpecProp_RS.Property[0].Descriptions?.[0]?.Description?.map(
            (description) => {
              return {
                house_rules:
                  description?.HouseRules != null
                    ? description?.HouseRules[0]
                    : "",
              };
            }
          ),
        description:
          jsonResult.Pull_ListSpecProp_RS.Property[0].Descriptions?.[0]?.Description?.map(
            (description) => {
              return {
                language_id: description["$"].LanguageID,
                text: description.Text[0],
              };
            }
          ),
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
      }));

    var bodyDetailLocation = {
      Pull_GetLocationDetails_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        LocationID: mappedPropertiesRentals[0].location_id,
      },
    };
    var jsonResultLocation = await getRentalsResponse(
      bodyDetailLocation,
      "Pull_GetLocationDetails_RQ"
    );

    const mappedLocation =
      jsonResultLocation.Pull_GetLocationDetails_RS.Locations[0].Location.filter(
        (location) => ["2", "3", "4"].includes(location["$"].LocationTypeID)
      ).reduce((acc, location, index, arr) => {
        acc["id"] = mappedPropertiesRentals[0].location_id;
        if (!acc["name"]) {
          acc["name"] = location["_"];
        } else {
          acc["name"] += ", " + location["_"];
        }
        return acc;
      }, {});

    const { deposit_id, amenities, room, paiement } =
      mappedPropertiesRentals[0];

    // get informations from database with ids of rentals
    const [depositNames, amenityNames, roomNames, paiementNames, images] =
      await Promise.all([
        fetchNames([deposit_id], "type_deposit"),
        fetchNames(
          amenities.map((amenity) => amenity.amenity_id),
          "amenity"
        ),
        fetchNames(
          room.map((room) => room.room_id),
          "type_room"
        ),
        fetchNames(
          paiement.map((paiement) => paiement.payement_id),
          "type_payement"
        ),
        getImageByPropertyId(ID),
      ]);

    // delete properties with id to replaces with object containing names
    const mappedProperties = mappedPropertiesRentals.map((property) => {
      const updatedProperty = { ...property };

      delete updatedProperty.location_id;
      delete updatedProperty.amenities;
      delete updatedProperty.paiement;
      delete updatedProperty.room;
      delete updatedProperty.deposit_id;

      updatedProperty.location = mappedLocation;
      updatedProperty.amenity = amenityNames;
      updatedProperty.paiement = paiementNames;
      updatedProperty.room = roomNames;
      updatedProperty.images = images;
      updatedProperty.deposit = depositNames.map((deposit) => {
        return {
          id: deposit.id,
          name: deposit.name,
          value: mappedPropertiesRentals[0].deposit_value,
        };
      });
      delete updatedProperty.deposit_value;
      return updatedProperty;
    });
    return res.status(200).json({ mappedProperties });
  } catch (error) {
    return res.status(500).json({ message: error });
  }
};
exports.getCalendarPropertyId = async (req, res) => {
  const ID = req.params.id;
  const locationId = req.params.location;
  try {
    var bodyAvailibility = {
      Pull_ListPropertiesBlocks_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        LocationID: locationId,
        DateFrom: getDate(0, "years"),
        DateTo: getDate(1, "years"),
      },
    };
    var jsonResultPrice = await getRentalsResponse(
      bodyAvailibility,
      "Pull_ListPropertiesBlocks_RQ"
    );

    const mappedCalendar =
      jsonResultPrice.Pull_ListPropertiesBlocks_RS.Properties[0].PropertyBlock.filter(
        (row) => Number(row["$"].PropertyID) === Number(ID)
      ).flatMap((property) =>
        property.Block.map((block) => {
          const dateFrom = block.DateFrom[0];
          const dateTo = block.DateTo[0];
          let adjustedDateTo;

          if (dateFrom === dateTo) {
            adjustedDateTo = dateTo;
          } else {
            adjustedDateTo = getDate(1, "days", "-", dateTo);
          }

          return {
            block: {
              date_from: dateFrom,
              date_to: adjustedDateTo,
            },
          };
        })
      );

    return res.status(200).json({ mappedCalendar });
  } catch (error) {
    return res.status(500).json({ message: error });
  }
};

exports.getPriceProperty = async (req, res) => {
  try {
    const { id, dateFrom, dateTo } = req.body;
    var body = {
      Pull_GetPropertyAvbPrice_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        PropertyID: id,
        DateFrom: dateFrom,
        DateTo: dateTo,
      },
    };

    const resultJson = await getRentalsResponse(
      body,
      "Pull_GetPropertyAvbPrice_RQ"
    );
    return res.status(200).json(resultJson);
  } catch (error) {
    return res.status(500).json(error);
  }
};

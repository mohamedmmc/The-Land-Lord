const xml2js = require("xml2js");
const axios = require("axios");
const { constantId } = require("../helper/constants");
const { downloadImage, saveImage } = require("../helper/image");
const path = require("path");
const { log } = require("console");
const { PropertyImage } = require("../models/property_image_model");
const { Property } = require("../models/property_model");
const {
  checkImageExists,
  uploadImage,
  isLinkValid,
} = require("../middlewares/cloudinary");
function addAuthentication(body, targetProperty) {
  const targetObject = body[targetProperty];

  const authentication = {
    UserName: process.env.RENTALS_UNITED_LOGIN,
    Password: process.env.RENTALS_UNITED_PASS,
  };
  targetObject.Authentication = authentication;

  return body;
}
function convertJsonToXml(jsonObj, root = "root") {
  const builder = new xml2js.Builder({ headless: true });

  const xml = builder.buildObject(jsonObj, root);
  return xml;
}
function convertXmlToJson(xmlData) {
  const parser = new xml2js.Parser();
  return new Promise((resolve, reject) => {
    parser.parseString(xmlData, (err, jsonData) => {
      if (err) {
        reject(err);
      } else {
        resolve(jsonData);
      }
    });
  });
}

async function getRentalsResponse(body, xmlRoot) {
  const xmlData = convertJsonToXml(body, xmlRoot);
  const responseRentalsXml = await axios.post(
    process.env.RENTALS_UNITED_LINK,
    xmlData
  );
  return await convertXmlToJson(responseRentalsXml.data);
}
async function getDetailedProperties(propertyList) {
  const listDetailProperties = [];
  const listPropAmenity = [];
  const listRoomProp = [];
  const listImageProperty = [];
  const listPaiementProperty = [];
  const listDescriptionProperty = [];
  const listPriceProperty = [];

  for (const [index, property] of propertyList.entries()) {
    const ID = property.id;
    // const ID = propertyList[0].id;
    var body = {
      Pull_ListSpecProp_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        PropertyID: ID,
      },
    };
    var bodyPrice = {
      Pull_ListPropertyPrices_RQ: {
        Authentication: {
          UserName: process.env.RENTALS_UNITED_LOGIN,
          Password: process.env.RENTALS_UNITED_PASS,
        },
        PropertyID: ID,
        DateFrom: getDate(0, "years"),
        DateTo: getDate(1, "years"),
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
          floor: property.Floor[0],
          street: property.Street[0],
          zip_code: property.ZipCode[0],
          coordinates: property.Coordinates[0],
          // arrival_instructions: {
          //   landlord: property.ArrivalInstructions[0].Landlord[0],
          //   pickupService: property.ArrivalInstructions[0].PickupService[0],
          //   email: property.ArrivalInstructions[0].Email[0],
          //   phone: property.ArrivalInstructions[0].Phone[0],
          //   howToArrive: property.ArrivalInstructions[0].HowToArrive[0],
          //   daysBeforeArrival:
          //     property.ArrivalInstructions[0].DaysBeforeArrival[0],
          // },
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

      if (mappedProperties[0].is_active === "true") {
        var jsonResultPrice = await getRentalsResponse(
          bodyPrice,
          "Pull_ListPropertyPrices_RQ"
        );

        const mappedPriceProperty =
          jsonResultPrice.Pull_ListPropertyPrices_RS.Prices?.[0]?.Season?.map(
            (season) => {
              return {
                property_id: ID,
                price: season.Price[0],
                date_from: season["$"].DateFrom,
                date_to: season["$"].DateTo,
              };
            }
          );

        // data of table association amenities and property
        const mappedPropAmenity =
          jsonResult.Pull_ListSpecProp_RS.Property[0].Amenities?.[0]?.Amenity?.map(
            (amenity) => {
              return {
                property_id: ID,
                amenity_id: amenity["_"],
                count: amenity["$"].Count,
              };
            }
          );

        // data of table association room and property
        const mappedPropRoom =
          jsonResult.Pull_ListSpecProp_RS.Property[0].CompositionRoomsAmenities?.[0]?.CompositionRoomAmenities?.map(
            (room) => {
              return {
                property_id: ID,
                room_id: room["$"].CompositionRoomID,
              };
            }
          );

        // data of table association image and property
        const mappedImagePromises = await resizeImageFromRentalsWithCloudinary(
          jsonResult.Pull_ListSpecProp_RS.Property[0].Images?.[0]?.Image,
          ID
        );

        // Wait for all image processing promises to resolve
        const mappedImagePropNullable = await Promise.all(mappedImagePromises);

        const mappedImageProp = mappedImagePropNullable.filter(
          (obj) => Object.keys(obj).length !== 0
        );
        // data of table association paiment and property
        const mappedPaiementProperty =
          jsonResult.Pull_ListSpecProp_RS.Property[0].PaymentMethods?.[0]?.PaymentMethod?.map(
            (paiement) => {
              return {
                property_id: ID,
                payement_id: paiement["$"].PaymentMethodID,
              };
            }
          );

        // data of table descriptin of property
        const mappedDescription =
          jsonResult.Pull_ListSpecProp_RS.Property[0].Descriptions?.[0]?.Description?.map(
            (description) => {
              return {
                property_id: ID,
                language_id: description["$"].LanguageID,
                text: description.Text[0],
                house_rules:
                  description?.HouseRules != null
                    ? description?.HouseRules[0]
                    : "",
              };
            }
          );
        if (mappedPropAmenity) listPropAmenity.push(mappedPropAmenity);
        if (mappedPropRoom) listRoomProp.push(mappedPropRoom);
        if (mappedProperties) listDetailProperties.push(mappedProperties);
        if (mappedImageProp) listImageProperty.push(mappedImageProp);
        if (mappedPaiementProperty)
          listPaiementProperty.push(mappedPaiementProperty);
        if (mappedDescription) listDescriptionProperty.push(mappedDescription);
        if (mappedPriceProperty) listPriceProperty.push(mappedPriceProperty);
        console.log(`${index} of ${propertyList.length}`);
        // }
      }
    } catch (error) {
      console.error(`Error fetching details for property ${ID}`, error);
    }
  }
  return {
    listDetailProperties,
    listPropAmenity,
    listRoomProp,
    listImageProperty,
    listPaiementProperty,
    listDescriptionProperty,
    listPriceProperty,
  };
}

function getDate(num, unit, operator = "+", dateString = "") {
  if (dateString) {
    if (!/\d{4}-\d{2}-\d{2}/.test(dateString)) {
      throw new Error('Invalid date format. Use "YYYY-MM-DD".');
    }
  }

  // Handle operator validation and calculation as before:

  // Use today's date if no dateString is provided:
  const date = dateString ? new Date(dateString) : new Date();

  if (unit === "days") {
    date.setDate(date.getDate() + (operator === "+" ? num : -num));
  } else if (unit === "months") {
    date.setMonth(date.getMonth() + (operator === "+" ? num : -num));
  } else if (unit === "years") {
    date.setFullYear(date.getFullYear() + (operator === "+" ? num : -num));
  } else {
    throw new Error('Invalid unit. Use "days", "months", or "years".');
  }

  const formattedDate = date.toISOString().slice(0, 10);
  return formattedDate;
}

function calculateDateDifference(date1Str, date2Str, unit = "days") {
  const date1 = new Date(date1Str);
  const date2 = new Date(date2Str);

  if (isNaN(date1.getTime()) || isNaN(date2.getTime())) {
    throw new Error("Invalid date format. Please use YYYY-MM-DD.");
  }

  const differenceInMilliseconds = Math.abs(date2.getTime() - date1.getTime());

  switch (unit) {
    case "days":
      return Math.floor(differenceInMilliseconds / (1000 * 60 * 60 * 24));
    case "weeks":
      return Math.floor(differenceInMilliseconds / (1000 * 60 * 60 * 24 * 7));
    case "months":
      const monthDifference =
        date2.getFullYear() * 12 +
        date2.getMonth() -
        (date1.getFullYear() * 12 + date1.getMonth());
      return monthDifference;
    case "years":
      return date2.getFullYear() - date1.getFullYear();
    default:
      throw new Error(
        "Invalid unit. Use 'days', 'weeks', 'months', or 'years'."
      );
  }
}

function resizeImageFromRentals(list, ID) {
  // Directly filter images within the map function for conciseness
  return list.map(async (image, index) => {
    const imageUrl = image["_"];
    // Only process images matching the specified URL pattern
    const imageName = `${ID}_${index}.jpg`;
    try {
      const founedProperty = await PropertyImage.findOne({
        where: {
          url: imageUrl,
        },
      });
      if (!founedProperty) {
        const imageBuffer = await downloadImage(imageUrl);
        await saveImage(imageName, imageBuffer);
      }
    } catch (error) {
      console.error("Error processing image:", error);
      // Return an empty object to signify an error
      return {};
    }

    return {
      url: imageUrl,
      property_id: ID,
      thumbnail: photoCloudinary.url,
    };
  });
}
async function resizeImageFromRentalsWithCloudinary(list, ID) {
  // Directly filter images within the map function for conciseness
  return Promise.all(
    list.map(async (image, index) => {
      const imageUrl = image["_"];
      let thumbnail;
      const imageName = `${ID}_${index}.jpg`;
      try {
        // Check if the image exists in the database
        const foundImage = await PropertyImage.findOne({
          where: {
            url: imageUrl,
          },
        });

        const linkValid = foundImage
          ? await isLinkValid(foundImage.thumbnail)
          : null;

        if (linkValid) {
          thumbnail = foundImage.thumbnail;
        } else {
          const imageBuffer = await downloadImage(imageUrl);
          const savedImage = await saveImage(imageName, imageBuffer);
          const uploadResult = await uploadImage(savedImage);
          if (!uploadResult) {
            console.error("error uploading image:", error);
            return {};
          }
          thumbnail = uploadResult.url;
        }
      } catch (error) {
        console.error("Error processing image:", error);
        return {};
      }

      return {
        url: imageUrl,
        property_id: ID,
        thumbnail: thumbnail,
      };
    })
  );
}
module.exports = {
  addAuthentication,
  convertJsonToXml,
  convertXmlToJson,
  getDetailedProperties,
  getDate,
  calculateDateDifference,
  getRentalsResponse,
};

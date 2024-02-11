const cloudinary = require("cloudinary").v2;

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

async function uploadImage(imagePath) {
  try {
    const result = await cloudinary.uploader.upload(imagePath);
    return { id: result.public_id, url: result.url };
  } catch (error) {
    console.error("Error uploading image to Cloudinary:", error);
    return null;
  }
}

async function checkImageExists(publicId) {
  try {
    const result = await cloudinary.api.resource(publicId);
    return result ? result : null;
  } catch (error) {
    console.error("Error checking image in Cloudinary:", error);
    return null;
  }
}
async function isLinkValid(url) {
  try {
    const response = await fetch(url, { method: "HEAD" });
    return response.ok;
  } catch (error) {
    return false;
  }
}
module.exports = {
  uploadImage,
  checkImageExists,
  isLinkValid,
};

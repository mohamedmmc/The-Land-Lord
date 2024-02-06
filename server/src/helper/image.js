const axios = require("axios");
const https = require("https");
const fs = require("fs");
const path = require("path");
const sharp = require("sharp");
const { execSync } = require("child_process");
// Function to download image from URL
async function downloadImage(imageUrl) {
  const response = await axios.get(imageUrl, {
    responseType: "arraybuffer",
    httpsAgent: new https.Agent({ rejectUnauthorized: false }), // Ignore SSL certificate errors
  });

  return Buffer.from(response.data, "binary");
}

// Function to save image
async function saveImage(imageName, imageBuffer) {
  const destinationDirectory = path.join(__dirname, "../../public/properties");
  if (!fs.existsSync(path.join(destinationDirectory))) {
    execSync(`mkdir "${path.join(destinationDirectory)}"`);
  }

  const imagePath = path.join(destinationDirectory, imageName);

  try {
    const resizedImageBuffer = await sharp(imageBuffer)
      .resize({ width: 800 })
      .toBuffer();

    fs.writeFileSync(imagePath, resizedImageBuffer);
    console.log(`Image ${imageName} saved successfully.`);

    return imagePath.replace(__dirname + "/public", "");
  } catch (error) {
    console.error("Error saving image:", error);
    throw error;
  }
}
function adjustString(inputString) {
  const jpgIndex = inputString.lastIndexOf(".jpg");
  const jpegIndex = inputString.lastIndexOf(".jpeg");
  const pngIndex = inputString.lastIndexOf(".png");

  const index = Math.max(jpgIndex, jpegIndex, pngIndex);

  if (index !== -1) {
    return inputString.substring(0, index + 4);
  } else {
    return inputString;
  }
}

module.exports = { downloadImage, saveImage, adjustString };

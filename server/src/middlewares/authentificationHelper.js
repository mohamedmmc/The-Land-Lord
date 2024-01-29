const jwt = require("jsonwebtoken");
// const { loadTranslations } = require("./helpers");

function tokenVerification(req, res, next) {
  let token = req.headers["authorization"];
  if (token) {
    let checkBearer = "Bearer ";
    if (token.startsWith(checkBearer)) {
      token = token.slice(checkBearer.length, token.length);
    }

    jwt.verify(token, process.env.JWT_SECRET_KEY, (err, decoded) => {
      if (err) {
        return res.status(403).json({
          success: false,
          message: "session_expired",
        });
      } else {
        req.decoded = decoded;
        next();
      }
    });
  } else {
    return res.status(403).json({
      message: "no_token_provided",
    });
  }
}
function roleMiddleware(roles) {
  return (req, res, next) => {
    const right = req.decoded?.right;

    if (roles.includes(right)) {
      next();
    } else {
      return res.status(403).send("access_denied");
    }
  };
}
module.exports = {
  tokenVerification,
  roleMiddleware,
};

const admin = require("firebase-admin");

var serviceAccount = require("./credentials/serviceAccountKey.json");

module.exports = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

module.exports = db;
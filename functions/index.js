const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Steps:
// npm install -g firebase-tools
// firebase init
// write functions to functions/index.js (here)
// firebase deploy (if 403, try firebase login and re-run deploy)
exports.myFunction = functions.firestore
    .document('requests/{entertainer.uid}/')
    .onCreate((snapshot, context) => {
        console.log(snapshot.data());
        admin.messaging().sendToTopic('requests/{entertainer.uid}/', {notification: {
            title: snapshot.data().username,
            body: snapshot.data().text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
    });


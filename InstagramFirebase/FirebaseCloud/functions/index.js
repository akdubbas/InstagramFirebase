const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase LBTA!");
});

exports.addPushNotifications = functions.https.onRequest((req,res) => {

  res.send("Attempting to send Push Notification")
  console.log("Trying to send push message..");
});

exports.sendPushNotifications =  functions.https.onRequest((req,res) => {

  res.send("Attempting to send Push Notification through custom function")
  console.log("Trying to send push messages..");

  // This registration token comes from the client FCM SDKs.
var fcmToken = "ce_DS94xz6Q:APA91bECHsUb5HPSGx3048-y3SMWFu9QIpqFpoORi3qknalXt9VNMLUQgMeew8ep3dAAQ1c4vK81_f2SX_eoxHOk5L5sVJsMzZPYIO6sBYErg-BsRq99cnZklpDm_8m922-qR2hxtEj-";

// See documentation on defining a message payload.
var message = {
	  notification: {
	    title: "My first remote Notification",
	    body: "You have a follower"
	  },
	  data: {
	    score: '850',
	    time: '2:45'
	  }
	};

	// Send a message to the device corresponding to the provided
	// registration token.
	admin.messaging().sendToDevice(fcmToken,message)
	.then((response) => {
	    // Response is a message ID string.
	    console.log('Successfully sent message:', response);
	    return response
	  })
	  .catch((error) => {
	    console.log('Error sending message:', error);
	    throw new Error("Error sending message");
	  });

});

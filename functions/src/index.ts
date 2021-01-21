import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();


export const sendFCM = functions.https.onCall((data, context) => {
  var token = data["token"];
  var title = data["title"];
  var body = data["body"];

  var payload = {
    notification: {
      title: title,
      body: body
    }
  }

  var result = admin.messaging().sendToDevice(token, payload);
  return result;
})
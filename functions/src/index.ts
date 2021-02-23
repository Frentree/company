import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

export const test =


export const sendFCM = functions.https.onCall((data, context) => {
  var token = data["token"];
  var team = data["team"];
  var name = data["name"];
  var position = data["position"];
  var collection = data["collection"];
  var alarmId = data["alarmId"];

  var payload = {
    data: {
      title: team + " " + name + " " + position,
      body: collection,
      alarmId: alarmId,
      clickAction: 'FLUTTER_NOTIFICATION_CLICK',
    }
  };

  var options = {
      priority: 'high',
  };

  var result = admin.messaging().sendToDevice(token, payload, options);
  return result;
})
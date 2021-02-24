import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

export const test = functions.pubsub.schedule('43 15 * * *').timeZone('Asia/Seoul').onRun((context) => {
    const db = admin.firestore();
    var companyId:string[] = [];
    var companyRef = db.collection("company");
    var queryRef = companyRef.get().then(snapshot => {
        snapshot.forEach(doc => {
            companyId.push(doc.id);
            console.log("리스트");
            console.log(companyId);
        });
    });
    console.log(queryRef);
    console.log(companyId[0]);
    return null;
});

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
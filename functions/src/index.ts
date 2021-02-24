import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

export const createAttendanceDB = functions.pubsub.schedule('06 15 * * *').timeZone('Asia/Seoul').onRun(async (context) => {
    const db = admin.firestore();
    var companyId:string[] = [];
    var companyRef = db.collection("company");
    companyRef.get().then(snapshot => {
        snapshot.forEach(doc => {
            companyId.push(doc.id);
            /*console.log("리스트");
            console.log(companyId);*/
        });
    });
    const today = new Date();
    const utc = today.getTime() + (today.getTimezoneOffset() * 60 * 1000);
    const KR_TIME_DIFF = 9 * 60 * 60 * 1000;
    const kr_today = new Date(utc + (KR_TIME_DIFF));


    const year = kr_today.getFullYear(); // 년도
    const month = kr_today.getMonth();  // 월
    const date = kr_today.getDate();  // 날짜
    const createDate = new Date(year, month, date);


    console.log(today);
    console.log(kr_today);
   /* console.log(today.Date(year, month, date, 00, 00);*/


    const res = await db.collection("company").doc('HLX1HXB').collection("attendance").add({name : "name", createDate : createDate});

    console.log('Added document with ID: ', res.id);

    /*console.log(Date().getMonth());
    console.log(Date().getFullYear());*/

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
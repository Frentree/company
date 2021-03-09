import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

class Person {
    mail : string;
    name : string;
    token : string;
    constructor(mail: string, name: string, token: string) {
        this.mail = mail;
        this.name = name;
        this.token = token;
    }
};

var userInfo:Person[] = [];

export const createAttendanceDB = functions.pubsub.schedule('00 04 * * *').timeZone('Asia/Seoul').onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date();
    const utc = today.getTime() + (today.getTimezoneOffset() * 60 * 1000);
    const KR_TIME_DIFF = 9 * 60 * 60 * 1000;
    const kr_today = new Date(utc + (KR_TIME_DIFF));
    const year = kr_today.getFullYear(); // 년도
    const month = kr_today.getMonth();  // 월
    const date = kr_today.getDate() - 1;  // 날짜
    const createDate = new Date(year, month, date, 15);
   console.log('date =====> ', kr_today.getDay());
    var companyRef = db.collection("company");

    companyRef.get().then(snapshot => {
        snapshot.forEach(async doc => {
            await doc.ref.collection("user").get().then(snapshot => {
                snapshot.forEach(doc => {
                    var person = new Person(doc.data().mail, doc.data().name, doc.data().token);
                    userInfo.push(person);
                })
            })

            userInfo.forEach(async data => {
                console.log('name =====> ', data.name);
                console.log('data =====> ', data.mail);
                if(kr_today.getDay() != 0 && kr_today.getDay() != 6){
                    await db.collection("company").doc(doc.id).collection("attendance").add({name : data.name, createDate : createDate, mail : data.mail, attendTime : null});
                }
            })
            userInfo = [];
        });
    });
    return null;
});

export const onWorkCheck = functions.pubsub.schedule('05 09 * * *').timeZone('Asia/Seoul').onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date();
    const utc = today.getTime() + (today.getTimezoneOffset() * 60 * 1000);
    const KR_TIME_DIFF = 9 * 60 * 60 * 1000;
    const kr_today = new Date(utc + (KR_TIME_DIFF));
    const year = kr_today.getFullYear(); // 년도
    const month = kr_today.getMonth();  // 월
    const date = kr_today.getDate() - 1;  // 날짜
    const createDate = new Date(year, month, date, 15);

    var companyRef = db.collection("company");

    var payload = {
        data: {
          title : "onWork",
          body: "onWork",
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    companyRef.get().then(snapshot => {
        snapshot.forEach(async doc => {
            await doc.ref.collection("user").get().then(snapshot => {
                snapshot.forEach(doc => {
                    var person = new Person(doc.data().mail, doc.data().name, doc.data().token);
                    userInfo.push(person);
                })
            })

            userInfo.forEach(data => {
                doc.ref.collection("attendance").where("mail", "==" ,data.mail).where("createDate", "==", createDate).get().then(snapshot => {
                    snapshot.forEach(doc =>{
                        if(doc.data().attendTime == null && data.token != null){
                            admin.messaging().sendToDevice("eYQ9KmssSgGnI-pQDL2Bai:APA91bG2QdNYHClflSvQ12cQF8R4dUE_AYrVK6dHFCkUXS0cCg08-WHWlTCgGI95gaOYt6abZD2OSrHPczoGU5HlTUUPnwX42mjVU290fnqHJfP5FDA3Ln-3k5jLW-nHOI4l_lIRdR4U", payload);
                        }
                    })
                })
            })
            userInfo = [];
        });
    });
    return null;
});

export const offWorkCheck = functions.pubsub.schedule('05 18 * * *').timeZone('Asia/Seoul').onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date();
    const utc = today.getTime() + (today.getTimezoneOffset() * 60 * 1000);
    const KR_TIME_DIFF = 9 * 60 * 60 * 1000;
    const kr_today = new Date(utc + (KR_TIME_DIFF));
    const year = kr_today.getFullYear(); // 년도
    const month = kr_today.getMonth();  // 월
    const date = kr_today.getDate() - 1;  // 날짜
    const createDate = new Date(year, month, date, 15);

    var companyRef = db.collection("company");

    var payload = {
        data: {
          title : "offWork",
          body: "offWork",
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        }
    };

    companyRef.get().then(snapshot => {
        snapshot.forEach(async doc => {
            await doc.ref.collection("user").get().then(snapshot => {
                snapshot.forEach(doc => {
                    var person = new Person(doc.data().mail, doc.data().name, doc.data().token);
                    userInfo.push(person);
                })
            })

            userInfo.forEach(data => {
                doc.ref.collection("attendance").where("mail", "==" ,data.mail).where("createDate", "==", createDate).get().then(snapshot => {
                    snapshot.forEach(doc =>{
                        if(doc.data().attendTime != null && data.token != null && doc.data().endTime == null){
                            admin.messaging().sendToDevice(data.token, payload);
                        }
                    })
                })
            })
            userInfo = [];
        });
    });
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
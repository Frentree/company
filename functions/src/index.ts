import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

/*const db = admin.firestore();*/
const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('user/{userId}')
  .onCreate(async snapshot => {
    const user = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Puppy!',
        body: `${user.name} is ready for adoption`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToTopic('user', payload);
  });

export const sendToDevice2 = functions.firestore
  .document('user/{userId}')
  .onCreate(async snapshot => {
    console.log('This will be run every 5 minutes!');
    const user = snapshot.data();

/*    const querySnapshot = await db
      .collection('user')
      .doc('test2@abc.com')
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);*/

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `you sold a ${user.name} for ${user.namel}`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
    console.log('This will be run every 5 minutes!');
   functions.pubsub.schedule('every 2 minutes').timeZone('Asia/Seoul').onRun((context) => {
        console.log('This will be run every 1 minutes!');
        fcm.sendToDevice('eEW5Ty1qTSmubO8IvRc4Rt:APA91bEZFO-XMS_clbTOoEX4tSlTRRJzhvVIM3SQ4yg7LD9hOFSjDmwG5IrLodiGJsLaA6lnFUpDLKeeGt_vsj_fjFT5ybaQuZnqAECXW5_JyPN87YR2OS0xwFs66lXzCZj31Vm-BMkD', payload);
    });
  });

/*
export const sendToTime = functions.pubsub.schedule(time).timeZone('Asia/Seoul').onRun((context) => {
        const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `you sold a`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
        fcm.sendToDevice('eEW5Ty1qTSmubO8IvRc4Rt:APA91bEZFO-XMS_clbTOoEX4tSlTRRJzhvVIM3SQ4yg7LD9hOFSjDmwG5IrLodiGJsLaA6lnFUpDLKeeGt_vsj_fjFT5ybaQuZnqAECXW5_JyPN87YR2OS0xwFs66lXzCZj31Vm-BMkD', payload);
});*/

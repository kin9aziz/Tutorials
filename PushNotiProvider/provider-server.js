var apn = require('apn');
var options = {
  cert: "cert.pem",
  key: "key.pem",
  production: false
};
let deviceToken = "1092cdb32d8bb781262b96fe4c2e3108fa6232e2e4fa5d0bdf0ef4e56388c777"

var invitation = new apn.Notification();
invitation.title = "A new meeting invitation.";
invitation.body = "Quang Tran wants to meet with you";
invitation.payload = {'messageFrom': 'Quang Tran'};
invitation.mutableContent = 1;
invitation.badge = 5;
invitation.sound = "default";
invitation.category = "MEETING_INVITATION"

var apnProvider = new apn.Provider(options);
apnProvider.send(invitation, deviceToken).then( (result) => {
  // see documentation for an explanation of result
  console.log('result: ' + result)
});
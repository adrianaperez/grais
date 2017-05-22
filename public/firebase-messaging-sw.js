importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-messaging.js');

var config = {
  apiKey: "AlzaSyCAUwy3JH6WZCj2YNRsqPD26Gegdab62ow",
  authDomain: "gerais-98c80.firebaseapp.com",
  databaseURL: "https://gerais-98c80.firebaseio.com",
  projectId: "gerais-98c80",
  storageBucket: "gerais-98c80.appspot.com",
  messagingSenderId: "530165822986"
};

firebase.initializeApp(config);

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
  console.log("Verificando");
});

////////////////////////////
self.addEventListener('push', function(event) {
  if (event.data) {
    var d = JSON.parse( event.data.text());

    const promiseChain = clients.matchAll({
      type: 'window',
      includeUncontrolled: true
    })
    .then((windowClients) => {
      let clientIsFocused = false;

      for (let i = 0; i < windowClients.length; i++) {
        const windowClient = windowClients[i];
        if (windowClient.focused) {
          clientIsFocused = true;
          break;
        }
      }
      for (let i = 0; i < windowClients.length; i++) {
        const windowClient = windowClients[i];
        console.log(windowClient.visibilityState);
      }
      console.log(clientIsFocused);
      if(clientIsFocused){
        windowClients.forEach((windowClient) => {
          windowClient.postMessage({
            message: 'Received a push message.',
            data: d
          });
        });
      }
    });
    event.waitUntil(promiseChain);
  } else {
    console.log('This push event has no data.');
  }
});



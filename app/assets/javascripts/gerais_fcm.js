document.addEventListener("turbolinks:load", function() {
 
  // Initialize Firebase
  var config = {
    apiKey: "AlzaSyCAUwy3JH6WZCj2YNRsqPD26Gegdab62ow",
    authDomain: "gerais-98c80.firebaseapp.com",
    databaseURL: "https://gerais-98c80.firebaseio.com",
    projectId: "gerais-98c80",
    storageBucket: "gerais-98c80.appspot.com",
    messagingSenderId: "530165822986"
  };
  firebase.initializeApp(config);

  //Aqui bebería obtener el token y enviarlo al servidor

  const messaging = firebase.messaging();

  messaging.requestPermission()
  .then(function() {
    console.log('Notification permission granted.');
    console.log(messaging.getToken());
    return messaging.getToken();
  })
  .then(function(token) {
    console.log(token);
    setTokenToServer(token);
  })
  .catch(function(err) {
    console.log('Unable to get permission to notify.', err);
  });

  messaging.onMessage(function(payload){
    console.log('onMessage:', payload);
    $('#aqui').append("Solicitud de: "+payload.data.user_name);
  });

  navigator.serviceWorker.addEventListener('message', function(event) {  
    console.log('Received a message from service worker: ', event.data.message);
    $.each( event.data , function( index, item ) {
      if (index =="message") {
        console.log('Received a message from service worker: ', event.data);
      }
      if (index =="data") {
        $('#aquiaqui').append("Solicitado por: "+item.data.user_name);
      }
    });
  });


});

function setTokenToServer(token){

  $.ajax({

    url: '/set_token',
    type: 'POST',
    dataType: 'json',
    data:{fcm_token:token},

    success:function(data){

     console.log("Token enviado");
    },

    error: function(data){

      console.log("Error al enviar token");
    }
  });
}
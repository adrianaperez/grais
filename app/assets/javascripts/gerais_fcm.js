document.addEventListener("turbolinks:load", function() {
  //<script src="https://www.gstatic.com/firebasejs/3.9.0/firebase.js"></script>
  //<script>
    // Initialize Firebase
    var config = {
      apiKey: "AIzaSyB4DvvSXF-VqUSPvz_YtiEJ2jYqf1FqT7U",
      authDomain: "geraisapp-6b1be.firebaseapp.com",
      databaseURL: "https://geraisapp-6b1be.firebaseio.com",
      projectId: "geraisapp-6b1be",
      storageBucket: "geraisapp-6b1be.appspot.com",
      messagingSenderId: "433408545786"
    };
    firebase.initializeApp(config);
  //</script>

  //Aqui de bebería obtener el token y enviarlo al servidor a través del formulario

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
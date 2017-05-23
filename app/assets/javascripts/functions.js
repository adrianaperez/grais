document.addEventListener("turbolinks:load", function() {

  //////////////////////////////////////////////////
  //Inicializar elementos del framework Materialize

  $(".button-collapse").sideNav();
  $(".sidebarr").sideNav();
  $('.parallax').parallax();
  $('.modal').modal();
  $('select').material_select();

  $('.datepicker').pickadate({
    container: 'body',
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15, // Creates a dropdown of 15 years to control year
    monthsFull: [ 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octobre', 'Noviembre', 'Diciembre' ],
    monthsShort: [ 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic' ],
    weekdaysFull: [ 'Domingo', 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado' ],
    weekdaysShort: [ 'Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab' ],
    today: 'Hoy',
    clear: 'Limpiar',
    close: 'Cerrar',
    format: 'yyyy-mm-dd'
  });
  

  /////////////////////////////////////////////////
  //Sticky Header para mobile
  stickyHeader();

  //////////////////////////////////////////////
  //Notificaciones
  notificationControl();
  $('#hidebar').click(function(){
    $('#notification').slideUp(500);
    activeNotification(false);
  });
  $('#logout').click(function(){
    if (!isNotificationActive()) {
      activeNotification(true);
    }    
  });

  //deleteLocalNotification();

  $( "#note" ).click(function() {
    $( this ).toggleClass( "show_notification" );
  });

});

///////////////////////////////////////////////
//Notificaciones
function notificationControl(){

  if (!window.localStorage.getItem('notification_enabled')) {
    console.log(window.localStorage.getItem('notification_enabled'));
    activeNotification(true);
    $('#notification').slideDown(500);
  } else {

    if (isNotificationActive()) {

      $('#notification').slideDown(500);
    }
  }
}

function isNotificationActive() {
  return window.localStorage.getItem('notification_enabled') == 1;
}

function activeNotification(sent) {
  window.localStorage.setItem('notification_enabled', sent ? 1 : 0);
}

function deleteLocalNotification (){
  window.localStorage.removeItem('notification_enabled');
}

///////////////////////////////////////////////
//Sticky Header

function stickyHeader(){

  $(window).scroll(function(){
    var height_header = $("header").height();
    var p = $("#parax").height();
    var current_position = $(this).scrollTop();
    //var position_menu = $(".wrapper-submenu").offset();
    //console.log("la posicion de parax "+ p);
    if (current_position > p) {
      $(".submenu").addClass("pinned");
      $(".submenu").css("top", height_header);
    } else {
      $(".submenu").removeClass("pinned");
      $(".submenu").css("top", "auto");
    }
  });
}


/////////////////////////////////////////////////////////////
//Función para reiniciar el modal si el resultado es exitoso

(function($) {

  $.fn.modal_success = function(){

    this.modal('close'); // Función de Materialize
    this.find('form input[type="text"]').val('');
    this.find('form input[type="checkbox"]').removeAttr('checked');
  };
}(jQuery));

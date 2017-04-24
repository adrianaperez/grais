document.addEventListener("turbolinks:load", function() {

  

  /////////////////////////////////////////////////
  //Sticky Header para mobile
  stickyHeader();

  //Obtener el tab inicialmente activado
  var tab_actived = $("ul.tabs li a.active");
  if(tab_actived.attr('href')=="#teams"){
    $("#teams .collection").empty();
    getCourseTeams();  
  }

  //Obtener todos los cursos
  $('#get_all_courses').click(function(){
    $("#all_courses").empty();
    getAllCourses();
  });  

  //Obtener los miembros del curso
  $('#get_course_members').click(function(){
    $("#course_members .collection").empty();
    getCourseMembers();
  });

  //Obtener los productos del curso
  $('#get_course_products').click(function(){
    $("#course_products .collection").empty();
    getCourseProducts();
  });

  //Agregar miembros al curso
  addMemberToCourse();

});



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

/////////////////////////////////////////////
//Peticiones AJAX

/////////////////////////////////////////////
//Obtener todos los cursos

function getAllCourses(){

  $.ajax({

    url: 'courses/all',
    type: 'POST',
    dataType: 'json',

    success:function(data){

      var count_course = 0;
      $.each( data , function( index, item ) {

        if (index =="courses") {
          count_course = item.length;
        }

        $.each(item, function(key, value){
          $('#all_courses').append(
            '<a href="/courses/' + value.id + '">' +
              '<div class="wrapper-card">' +
                '<div class="card-course">' +
                  '<div class="wrapper-img">' +
                    '<img src="/assets/Neuschwanstein.jpg" alt="Neuschwanstein">' +
                  '</div>' +
                  '<div class="wrapper-content">' +
                    '<div class="content">' +
                      '<p>'+ value.name + '</p>' +
                      '<p>'+ value.description + '</p>' +
                    '</div>' +
                  '</div>' +
                '</div>' +
              '</div>'+
            '</a>'
          );   
        });
      });
      if (count_course==0) {
        $('#all_courses').append('<h4 class="center" style="color: #94b8b8; font-weight: bold;">No hay cursos disponibles en la herramienta</h4>');
      }
    },

    error: function(data){

      
    }
  });
}

/////////////////////////////////////////////
// Obtener los equipos de un curso

function getCourseTeams(){

  var course_id = $('div#course_id').attr('data-id');

  $.ajax({

    url: '/teams/find_teams_by_course',
    type: 'POST',
    dataType: 'json',
    data:{id:course_id},

    success:function(data){

      $.each( data , function( index, item ) {
         $.each(item, function(key, value){
          $('div#teams .collection').append(
            '<li class="collection-item avatar">' +
              '<a href="/teams/' + value.id + '">' +
                '<img src="/assets/e-learning.png" alt="e-learning" class= "circle">' +
                '<span class="title">'+ value.name +'</span>' +
                '<p> Cantidad de estudiantes '+ value.studentsAmount +'</p>' +
              '</a>'+
            '</li>'
          );
         });
      });
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}

/////////////////////////////////////////////
// Obtener los miembros de un curso

function getCourseMembers (){

  var course_id = $('div#course_id').attr('data-id');

  $.ajax({

    url: '/courses/find_members_by_course',
    type: 'POST',
    dataType: 'json',
    data:{id: course_id},

    success:function(data){

      $.each( data , function( index, item ) {
         $.each(item, function(key, value){
          $('div#course_members .collection').append(
            '<li class="collection-item avatar">' +
                '<img src="/assets/user_boy.svg" alt="user_boy" class= "circle">' +
                '<span class="title">'+ value.names_user +'</span>' +
            '</li>'
            );
         });
      });
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}

////////////////////////////////////
//Obtener los productos de un curso

function getCourseProducts (){

  var course_id = $('div#course_id').attr('data-id');

  $.ajax({

    url: '/products/find_products_by_course',
    type: 'POST',
    dataType: 'json',
    data:{id:course_id},

    success:function(data){
      
      $.each( data , function( index, item ) {
         $.each(item, function(key, value){
          $('div#course_products .collection').append(
            '<a href="/products/' + value.id + '">' +
              '<li class="collection-item avatar">' +
                  '<img src="/assets/typewriter-01.svg" alt="user_boy" class= "circle">' +
                  '<span class="title">'+ value.name +'</span>' +
              '</li>'+
            '</a>'
            );
         });
      });
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}

///////////////////////////
//Agregar miembros al curso

function addMemberToCourse() {

  $('form[id=add_member_to_course]').submit(function(event) {  
    event.preventDefault();
    var valuesToSubmit = $(this).serialize();
    
    console.log(valuesToSubmit);
    console.log($(this).attr('action'));

    $.ajax({

      url: $(this).attr('action'),
      type: 'POST',
      dataType: 'json',
      data: valuesToSubmit,

      success:function(data){
  
        if (data.status=="unprocessable_entity" || data.status=="not_found") {
          console.log("No se pudo inscribir");
        } else {
          console.log("Inscripción exitosa");
        }
      },
      error: function(xhr){

        console.log("Error al cambiar la contraseña");
      }
    });
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
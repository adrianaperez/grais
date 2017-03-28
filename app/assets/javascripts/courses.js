var tab_all_courses = "false";
var tab_initial = "false";

document.addEventListener("turbolinks:load", function() {

  var tab_actived = $("ul.tabs li a.active");

  console.log("El tab activado es: " + tab_actived);

  if(tab_actived.attr('href')=="#teams"){
    console.log("Está funcinando");
    //$('div#teams').append("<h5>Está funcionando</h5>");
    if (tab_initial=="false") {get_teams();}
    
  }

  $('#get_all_courses').click(function(){
    //if ( $('#get_all_courses').attr("data-clicked") == "true") {console.log("iguales");} else {console.log("distintas");}
    //console.log("Click " + $('#get_all_courses').attr("data-clicked")); 
    //$("#all_courses").empty();
    console.log("Este es el valor de la variable global " + tab_all_courses);
    if(tab_all_courses == "false"){
      console.log("Atendiendo la peticion"); 

      $.ajax({

        url: 'courses/all',
        type: 'POST',
        dataType: 'json',

        success:function(data){
          tab_all_courses = "true";
          //$('#get_all_courses').attr("data-clicked", "true");
          $.each( data , function( index, item ) {
            $.each(item, function(key, value){
              console.log("Imprimiendo...");
              console.log(key +": " + value);
              console.log("======================================");
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
            

            /*$.each(item, function(key, value){
              console.log(key +": " + value);
              $('#all_courses').append('<span>'+ value +'</span>');
               
            });*/
          });
        },

        error: function(data){

          
        }

      });
    }
  });  


  //////////////////////////////
  //Checkbox del form del curso

  $('input:checkbox').on( 'change', function() {
      if( $(this).is(':checked') ) {
          $(this).val('1');
      } else {
          $(this).val('0');  
      }
  });

});

/////////////////////////////////////////////
// Función para obtener los equipos vía ajax

function get_teams(){

  $.ajax({

    url: '/teams/find_teams_by_course',
    type: 'POST',
    dataType: 'json',
    data:{id:1},

    success:function(data){
      tab_initial="true";
      console.log("funciono!");
      $.each( data , function( index, item ) {
         $.each(item, function(key, value){
          //$('div#teams').append("<h5>"+value.name+"</h5>");
          //$('div#teams .collection').append('<li class="collection-item"><a href="/teams/' + value.id + '">' + value.name + '</a></li>');
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
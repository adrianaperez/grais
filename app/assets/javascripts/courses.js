document.addEventListener("turbolinks:load", function() {
  $('#get_all_courses').click(function(){
    //if ( $('#get_all_courses').attr("data-clicked") == "true") {console.log("iguales");} else {console.log("distintas");}
    //console.log("Click " + $('#get_all_courses').attr("data-clicked")); 
    //$("#all_courses").empty();
    if($('#get_all_courses').attr("data-clicked") == "false"){
      console.log("Atendiendo la peticion"); 

      $.ajax({

        url: 'courses/all',
        type: 'POST',
        dataType: 'json',

        success:function(data){

          $('#get_all_courses').attr("data-clicked", "true");
          $.each( data , function( index, item ) {
            console.log("======================================");
            console.log("***"+item.name+"***");
            $('#all_courses').append(

              '<a href="/courses/' + item.id + '">' +
                '<div class="wrapper-card">' +
                  '<div class="card-course">' +
                    '<div class="wrapper-img">' +
                      '<img src="/assets/Neuschwanstein.jpg" alt="Neuschwanstein">' +
                    '</div>' +
                    '<div class="wrapper-content">' +
                      '<div class="content">' +
                        '<p>'+ item.name + '</p>' +
                        '<p>'+ item.description + '</p>' +
                      '</div>' +
                    '</div>' +
                  '</div>' +
                '</div>'+
              '</a>'

            );

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
});
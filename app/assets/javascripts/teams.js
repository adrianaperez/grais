document.addEventListener("turbolinks:load", function() {

  //Obtener el tab inicialmente activado
  var tab_members_team = $("ul.tabs li a.active");
  if(tab_members_team .attr('href')=="#team_products"){
    $("#team_products .collection").empty();
    get_team_products(); 
  }

  //Obtener productos del equipo
  $('#get_team_members').click(function(){
    $("#team_members .collection").empty();
    get_team_members();
  });

});

////////////////////////////////////
//Obtener los miembros de un equipo

function get_team_members (){

  var team_id = $('div#team_id').attr('data-id');

  $.ajax({

    url: '/teams/find_members_by_team',
    type: 'POST',
    dataType: 'json',
    data:{id:team_id},

    success:function(data){

      $.each( data , function( index, item ) {
         $.each(item, function(key, value){
          $('div#team_members .collection').append(
            '<li class="collection-item avatar">' +
                '<img src="/assets/user_boy.svg" alt="user_boy" class= "circle">' +
                '<span class="title">'+ value.names +'</span>' +
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
//Obtener los productos de un equipo

function get_team_products (){

  var team_id = $('div#team_id').attr('data-id');

  $.ajax({

    url: '/products/find_products_by_team',
    type: 'POST',
    dataType: 'json',
    data:{id:team_id},

    success:function(data){
      
      $.each( data , function( index, item ) {
         $.each(item, function(key, value){
          $('div#team_products .collection').append(
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


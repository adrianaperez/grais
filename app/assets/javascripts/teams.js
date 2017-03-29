document.addEventListener("turbolinks:load", function() {

  //Obtener 
  var tab_members_team = $("ul.tabs li a.active");
  if(tab_members_team .attr('href')=="#team_members"){
    console.log("Entró");
    get_team_members(); 
  }

  //Obtener productos del equipo
  $('#get_team_products').click(function(){
    $("#team_products .collection").empty();
    get_team_products();
  });

});

////////////////////////////////////
//Obtener los miembros de un equipo

function get_team_members (){

  $.ajax({

    url: '/teams/find_members_by_team',
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

function get_team_products (){

  $.ajax({

    url: '/products/find_products_by_team',
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
          $('div#team_products .collection').append(
            '<li class="collection-item avatar">' +
                '<img src="/assets/typewriter-01.svg" alt="user_boy" class= "circle">' +
                '<span class="title">'+ value.name +'</span>' +
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
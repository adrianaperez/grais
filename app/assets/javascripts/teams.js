document.addEventListener("turbolinks:load", function() {

  //Obtener el tab inicialmente activado
  var tab_members_team = $("ul.tabs li a.active");
  if(tab_members_team .attr('href')=="#team_products"){
    $("#team_products .collection").empty();
    get_team_products(); 
  }

  //Obtener los miembros del equipo
  $('#get_team_members').click(function(){
    $("#team_members .collection").empty();
    getTeamMembers();
  });

  //Obtener los productos prototipos del curso
  $('#select_product_prototype').click(function(){
    $("div#modal_select_product_prototype #select_prototype .modal-content").empty();
    getProductPrototypes();
  });

  //Seleccionar producto prototipo
  selectProductPrototype();
});

////////////////////////////////////
//Obtener los miembros de un equipo

function getTeamMembers (){

  var team_id = $('div#team_id').attr('data-id');

  $.ajax({

    url: '/teams/find_members_by_team',
    type: 'POST',
    dataType: 'json',
    data:{id:team_id},

    success:function(data){

      $.each( data , function( index, item ) {
        $.each(item, function(key, value){

          if (value.rol=="LEADER") {
            $('div#team_members .collection').append(
              '<li class="collection-item avatar">' +
                '<img src="/assets/user_boy.svg" alt="user_boy" class= "circle">' +
                '<span class="title">'+ value.names +'</span><br>' +
                '<span class="title">'+ "Lider" +'</span>'+
              '</li>'
            );
          } else {
            $('div#team_members .collection').append(
              '<li class="collection-item avatar">' +
                '<img src="/assets/user_boy.svg" alt="user_boy" class= "circle">' +
                '<span class="title">'+ value.names +'</span><br>' +
                '<span class="title">'+ "Miembro" +'</span>'+
              '</li>'
            );
          }
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

////////////////////////////////////
//Obtener los productos prototipos de un equipo

function getProductPrototypes (){

  var course_id = $('div#team_course_id').attr('data-id');
  var team_id = $('div#team_id').attr('data-id');

  $.ajax({

    url: '/prototypes/find_by_course',
    type: 'POST',
    dataType: 'json',
    data:{id:course_id},

    success:function(data){
      
      $.each( data , function( index, item ) {
        $.each(item, function(key, value){
          $('div#modal_select_product_prototype #select_prototype .modal-content').append(
            '<p>'+
              '<input name="prototype_id" type="radio" id="'+value.id+'" value="'+value.id+'"/>'+
              '<label for="'+value.id+'">'+value.name +'</label>'+

              '<input name="use_prototype" id="use_prototype" value="true" type="hidden">'+
              '<input name="product[name]" id="product_name" value="'+value.name+'" type="hidden">'+
              '<input name="product[description]" id="product_description" value="'+value.description+'" type="hidden">'+
              '<input name="product[logo]" id="product_logo" value="'+value.logo+'" type="hidden">'+
              '<input name="product[initials]" id="product_initials" value="'+value.initials+'" type="hidden">'+
              '<input name="product[team_id]" id="product_team_id" value="'+team_id+'" type="hidden">'+
              
            '</p>'
          );
        });
      });
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}

////////////////////////////////
//Seleccionar producto prototipo

function selectProductPrototype(){

  $('form[id=select_prototype]').submit(function( event) {  
    event.preventDefault();

    var p = $('input:radio[name=prototype_id]:checked').parent();
    var prototype_id = p.children('input:radio[name=prototype_id]').val();
    var use_prototype = p.children('input#use_prototype').val();
    var name = p.children('input#product_name').val();
    var description = p.children('input#product_description').val();
    var logo = p.children('input#product_logo').val();
    var initials = p.children('input#product_initials').val();
    var team_id = p.children('input#product_team_id').val();

    $.ajax({

      url:$(this).attr('action'),
      type: 'POST',
      dataType: 'script',
      data:{
        "prototype_id":prototype_id,
        "use_prototype":use_prototype,
        "product[name]":name,
        "product[description]": description,
        "product[logo]":logo,
        "product[initials]": initials,
        "product[team_id]": team_id
      },

      success:function(data){
         console.log("exito");
      },

      error: function(data){

        console.log("ocurrio un error");
      }
    });
    
  });
}
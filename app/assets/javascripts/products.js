document.addEventListener("turbolinks:load", function() {

  //Obtener el tab inicialmente activado
  var tab_members_team = $("ul.tabs li a.active");
  if(tab_members_team .attr('href')=="#product_commitments"){
    $("#product_commitments .collection").empty();
    getProductCommitments(); 
  }

  //Obtener las tareas de un usuario en particular
  $('#get_my_tasks').click(function(){
    $("#my_tasks .collection").empty();
    getMyTasks();
  }); 
});

function getProductCommitments(){

  var product = $('div#product_id').attr('data-id');

  $.ajax({

    url: '/commitments/find_by_product',
    type: 'POST',
    dataType: 'json',
    data:{product_id:product},

    success:function(data){

      $.each( data , function( index, item ) {
        $.each(item, function(key, value){

          $('div#product_commitments .collection').append(
            '<a href="/commitments/' + value.id + '">' +
              '<li class="collection-item">'+value.description+'</li>'+
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

function getMyTasks(){

  var user = $('div#user_id_tasks').attr('data-id');
  var product = $('div#product_id').attr('data-id');

  $.ajax({

    url: '/tasks/find_user_task_by_product',
    type: 'POST',
    dataType: 'json',
    data:{user_id:user, product_id:product},

    success:function(data){

      $.each( data , function( index, item ) {
        $.each(item, function(key, value){

          $('div#my_tasks .collection').append(   
            '<li class="collection-item">'+value.description+'<br>'+value.commitment_name+'</li>'
          );
        
        });
      });
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}
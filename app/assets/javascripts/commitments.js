document.addEventListener("turbolinks:load", function() {
  
  //Obtener las tareas del compromiso
  var tab_members_team = $("ul.tabs li a.active");
  if(tab_members_team .attr('href')=="#commitment_tasks"){
    $("#commitment_tasks .collection").empty();
    getCommitmentTask(); 
  }
});

function getCommitmentTask(){

  var commitment = $('div#commitment_id').attr('data-id');

  $.ajax({

    url: '/tasks/find_by_commitment',
    type: 'POST',
    dataType: 'json',
    data:{commitment_id:commitment},

    success:function(data){

      $.each( data , function( index, item ) {
        $.each(item, function(key, value){

          $('div#commitment_tasks .collection').append(
            '<li class="collection-item">'+value.description+'<br>'+value.user_name+'</li>'
          );
        
        });
      });
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}
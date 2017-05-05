document.addEventListener("turbolinks:load", function() {

  //Obtener los miembros del equipo para la tarea
  $('#link_new_task').click(function(){
    console.log("Entroooo");
    getTeamMembersCreateTask();
  });

});

function getTeamMembersCreateTask() {

  var team_id = $('div#commitment_product_team_id').attr('data-id');

  $.ajax({

    url: '/teams/find_members_by_team',
    type: 'POST',
    dataType: 'json',
    data:{id:team_id},

    success:function(data){

      $.each( data , function( index, item ) {
        $.each(item, function(key, value){

          $('form[id=new_task] select[id=task_user_id]').append(
            '<option value="'+value.id+'">'+value.names+'</option>'
          );
          $('select').material_select();
        });
      });
      $('select').material_select();
    },

    error: function(data){

      console.log("ocurrio un error");
    }
  });
}
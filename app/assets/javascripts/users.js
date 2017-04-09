document.addEventListener("turbolinks:load", function() {

  //Cambiar contraseña
  changePassword();
});

/////////////////////
//Cambiar contraseña

function changePassword() {

  $('form[id=change_password]').submit(function( event) {  
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
  
        if (data.status=="unprocessable_entity" || data.status=="unauthorized") {
          console.log("Error al cambiar la contraseña");;
        } else {
          $('#modal_change_password').modal_success();
        }
        //console.log(data.info);
        //console.log("Se cambio la contraseña ");
        //$.each( data , function( index, item ) {
          //console.log(index +" "+ item);
        //});
        //$('#modal_change_password').modal_success();
      },
      error: function(xhr){

        console.log("Error al cambiar la contraseña");
      }
    });
});

  /*$('button[type=submit][name=change_password]').on('click', function(event){

    var form = $(this).parent('form');
    
    event.preventDefault();
  
    $.ajax({

      url: form.attr('action'),
      type: 'POST',
      dataType: 'json',
      data: form.serialize(),

      success:function(data){

        console.log("Se cambio la contraseña");
        $('#modal_change_password').modal_success();
      },
      error: function(data){

        console.log("Error al cambiar la contraseña");
      }
    });
  });*/
}
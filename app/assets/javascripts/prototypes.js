document.addEventListener("turbolinks:load", function() {

  //Obtener el tab inicialmente activado
  var tab_actived = $("ul.tabs li a.active");
  if(tab_actived.attr('href')=="#product_prototype_commitments"){
    $("#product_prototype_commitments .collection").empty();
    getProductPrototypeCommitment(); 
  }

  //Obtener los compromisos del prototipo
  $('#get_product_prototype_commitments').click(function(){
    $("#product_prototype_commitments .collection").empty();
    getProductPrototypeCommitment();
  });

});

/////////////////////////////////////////////
//Peticiones AJAX

function getProductPrototypeCommitment(){

  var prototype_id = $('div#prototype_id').attr('data-id');

  $.ajax({

    url: '/commitments_prototypes/find_by_prototype',
    type: 'POST',
    dataType: 'json',
    data:{id:prototype_id},

    success:function(data){

      $.each( data , function( index, item ) {
        $.each(item, function(key, value){
          $('#product_prototype_commitments .collection').append(
            '<li class="collection-item">'+value.description+'</li>'
          );   
        });
      });
    },

    error: function(data){

      
    }
  });

}
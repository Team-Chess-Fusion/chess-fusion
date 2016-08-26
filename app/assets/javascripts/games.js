$(function(){
  $(".piece-font").draggable({
    snap: "td",
    snapMode: "inner",
    snapTolerance: 30,
  });

  $("td").droppable({
    drop: function(event, ui) {
      $.ajax({
          type: 'PUT',
          url: ui.draggable.data('update-url'),
          dataType: 'json',
          data: {piece: {row_coordinate: $(this).data("row"), column_coordinate: $(this).data("column")}}
      }).done(function(data){
        if (data.update_attempt === 'invalid move') {
          ui.draggable.animate({left : 0, top: 0},"slow");
        } else {
          if (data.in_check === true) {
            $(".check-status").text("Check!").addClass(".alert alert-warning");
          }
          else {
            $(".check-status").text("").removeClass(".alert alert-warning");
          }
          alert('next');
        }
      });
    },
  });
});
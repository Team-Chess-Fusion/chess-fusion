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
          } else {
            $(".check-status").text("").removeClass(".alert alert-warning");
          }
          if (data.move_color === 'white') {
           $(".move-turn").text("White to move");
          } else {
           $(".move-turn").text("Black to move");
          }
          if (data.stalemate === true) {
            $(".stalemate-status").text("Stalemate. Game Over!").addClass(".alert alert-warning");
          } else {
            $(".stalemate-status").text("").removeClass(".alert alert-warning");
          }
          if (data.promote_pawn !== null ) {
            $('#myModal').attr('data-pieceid', data.promote_pawn);
            $('#myModal').modal({
              backdrop: 'static',
              keyboard: false
            });            
          }
        }
      });
    },
  });

  $(".change-piece-button").click(function(){
    var url = "/pieces/"+$('#myModal').data('pieceid')+"/promote_pawn";
    $.ajax({
      type: 'PUT',
      url: url,
      dataType: 'json',
      data: {piece: {type: $(this).data('type')}}
    }).done(function(data){
      location.reload();
    });
  });
});
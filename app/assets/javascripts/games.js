$(function(){
// Enable pusher logging - don't include this in production
  Pusher.logToConsole = true;
  var pusher = new Pusher('00ac7dd60df12a2ee087', {
    encrypted: true
  });
  var game_id = $('.game-title').data('gameid');
  var channel = pusher.subscribe('game_channel-'+game_id);

  // Binding channel to events
  channel.bind('game_id', function(data) {
    if (data.player_color !== data.color_moved) {
      //Refresh the page      
      location.reload();
    }    
  });

  $(".piece-font").draggable({
    snap: "td",
    snapMode: "inner",
    snapTolerance: 30,
    containment: "table"
  });

  $("td").droppable({
    drop: function(event, ui) {
      var destination_square = $(this);
      var origin_square = ui.draggable.parent();
      $.ajax({
          type: 'PUT',
          url: ui.draggable.data('update-url'),
          dataType: 'json',
          data: {piece: {row_coordinate: $(this).data("row"), column_coordinate: $(this).data("column")}}
      }).done(function(data){
        console.log(data.update_attempt);
        if (data.update_attempt === 'invalid move') {
          ui.draggable.animate({left : 0, top: 0},"slow");
        } else {
          if (data.update_attempt === 'captured') {
            destination_square.empty();
          }

          if (data.update_attempt === 'castling') {
            location.reload();
          }

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

          if (data.update_attempt != 'castling'){
            resetPieceFrontendLocation(ui.draggable, destination_square);  
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

function resetPieceFrontendLocation(piece, destination) {
  piece.css({
    'left': 0,
    'top': 0
  });
  destination.append(piece);
}

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
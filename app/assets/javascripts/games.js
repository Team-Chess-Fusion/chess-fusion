$(function(){
// Enable pusher logging - don't include this in production
  Pusher.logToConsole = true;
  var pusher = new Pusher('00ac7dd60df12a2ee087', {
    encrypted: true
  });
  var game_id = $('.game-title').data('gameid');
  var channel = pusher.subscribe('game_channel-'+game_id);

  // Binding channel to events
  channel.bind('moved', function(data) {
    movePiece(data.origin_square, data.destination_square);
    changeTextStatus(data);
  });

  channel.bind('captured', function(data) {
    movePiece(data.origin_square, data.destination_square);
    var destination = $('td[data-row="'+data.destination_square['row']+'"][data-column="'+ data.destination_square['col']+'"]');
    destination.children(':first').remove();
    changeTextStatus(data);
  });  

  channel.bind('castling', function(data) {
    location.reload();
    changeTextStatus(data);
  });  

  channel.bind('promote_pawn', function(data) {
    location.reload();
    changeTextStatus(data);
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
          
          if (data.update_attempt != 'castling'){
            // Required as movement using draggable will alter position of element.
            // Subsequent moves will cause pieces to move out of position if not present
            resetPieceFrontendLocation(ui.draggable);  
          }
          
          if (data.promote_pawn !== null ) {
            $('#myModal').attr('data-pieceid', data.promote_pawn);
            $('#myModal').modal({
              backdrop: 'static',
              keyboard: false
            });            
          }

          if (data.checkmate === true || data.stalemate === true) {
            $(".piece-font").draggable('disable');
          }

        }
      });
    },
  });

  function resetPieceFrontendLocation(piece) {
    piece.css({
      'left': 0,
      'top': 0
    });
  }

  function movePiece(origin_square, destination_square) {
    var origin = $('td[data-row="'+origin_square['row']+'"][data-column="'+ origin_square['col']+'"]');
    var destination = $('td[data-row="'+destination_square['row']+'"][data-column="'+ destination_square['col']+'"]');
    var piece = origin.children('.piece-font').detach();
    destination.append(piece);      
  }

  function changeTextStatus (data) {
    if (data.in_check === true) {
      $(".check-status").text("Check!").addClass(".alert alert-warning");
    } else {
      $(".check-status").text("").removeClass(".alert alert-warning");
    }

    if (data.color_moved === 'white') {
     $(".move-turn").text("Black to move");
    } else {
     $(".move-turn").text("White to move");
    }

    if (data.stalemate === true) {
      $(".stalemate-status").text("Stalemate. Game Over!").addClass(".alert alert-warning");
    } else {
      $(".stalemate-status").text("").removeClass(".alert alert-warning");
    }  

    if (data.checkmate === true) {
      $(".checkmate-status").text("Checkmate! " + data.game_winner + " player wins the game").addClass(".alert alert-warning");
    } else {
      $(".checkmate-status").text("").removeClass(".alert alert-warning");
    }    
  }

  $(".change-piece-button").click(function(){
    var url = "/pieces/"+$('#myModal').data('pieceid')+"/promote_pawn";
    $.ajax({
      type: 'PUT',
      url: url,
      dataType: 'json',
      data: {piece: {type: $(this).data('type')}}
    });
  });
  
});
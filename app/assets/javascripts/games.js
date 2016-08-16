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
          data: {piece: {row_coordinate: $(this).attr("data-row"), column_coordinate: $(this).attr("data-column")}}
      });
    }
  });
});
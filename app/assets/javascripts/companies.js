$(document).on('ready page:load', function(){
  $("#company_sales_area_id").change(function() {
    var sub_sales_area = this.options[this.selectedIndex];
    $(this).getComboBoxValues(sub_sales_area.value, "#sub_sales_areas", "/sales_area/sub_sales_areas");
  });
});

$.fn.getComboBoxValues = function(selected_value, target_tag, url) {
  $.ajax({
    url: url,
    data: selected_value,
    dataType: "text",
    error: function(xhr, textStatus, errorThrown){
    	alert("Une erreur s'est produite: " + errorThrown);
    },
    success: function(response, response_status, xhr) {
      $(target_tag).children().remove();
      $(response).appendTo(target_tag);
    }
  });

  //////////////////////Create Holding modal/////////////////////////////////////
$(document).on("ajax:error", "#new_holding", function(event, xhr, status, error) {
  if(xhr.responseText.replace(/ /g,'') == "ok"){
    alert("Le groupe a été enregistré.");
    $(event.data).clear_previous_errors();
    $('#myGroupModal').modal('hide');
    $(event.data).getComboBoxValues(1, "#holdings", "/js_holdings");
  }
  else{
    $(event.data).render_form_errors($.parseJSON(xhr.responseText), "holding");
  }
});
//////////////////////Create Holding modal/////////////////////////////////////

$.fn.render_form_errors = function(errors, model){
  $form = this;
  this.clear_previous_errors();

  $.each(errors, function(field, messages){
    $input = $('#new_' + model + ' input[name="' + model + '[' + field + ']"]');
    $select = $('#new_' + model + ' select[name="' + model + '[' + field + ']"]');
    $textarea = $('#new_' + model + ' textarea[name="' + model + '[' + field + ']"]')

    $input.addClass('error');
    $select.addClass('error');
    $textarea.addClass('error');
  });
}

$.fn.clear_previous_errors = function(){
  $('.form-control.error').each(function(){
    $(this).removeClass('error');
  });
}
}

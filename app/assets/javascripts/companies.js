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
}

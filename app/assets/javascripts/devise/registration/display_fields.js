$(document).on('ready page:load', function(){ 
  $(this).hideNameSection();  
});

$.fn.hideNameSection = function() { 
  if ($("#user_profile_id :selected").text() == "Entreprise financière") {
    $("#name_section").hide(); 
    $("#company_section").show(); 
  }
  else
  {
    $("#name_section").show(); 
    $("#company_section").hide(); 
  }                 
}



$(document).on('ready page:load', function(){
  $("#company_section").hide();

  $("#user_profile_id").change(function() {
    var selected_profile = this.options[this.selectedIndex].text;

    if (selected_profile == 'Abonné'){
      $("#company_section").show('slow');
    }
    else{
      $("#company_section").hide('slow');
    }
  });
});

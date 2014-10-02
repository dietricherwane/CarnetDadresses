class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def layout_used 
  	if current_user.blank?
  	  "sessions"
  	else
  	  "back_office"
=begin
		  case current_user.profile.shortcut
	      when "ADMIN"
		      "administrator"
	      when "LV1"
		      "lvs"
	      when "LV2"
		      "lvs"
	      when "CD"
		      "cd"
	      when "CD-BD"
		      "cd_bd"
	      when "CSADP-BD"
		      "csadp_bd"
	      when "AGC"
	        "agc"
	      when "PE"
	        "pe"
		    else
		      "sessions"
	      end
=end
	  end			
  end 
  
  # Overwriting the sign_out redirect path method
	def after_sign_out_path_for(resource_or_scope)
		new_user_session_path
	end
	
	def after_sign_in_path_for(resource_or_scope)
		admin_dashboard_path			
	end
	
	def sign_out_disabled_users
    if current_user.published == false
      sign_out(current_user)
      flash[:notice] = "Votre compte a été désactivé. Veuillez contacter l'administrateur."
      redirect_to new_user_session_path
    end
  end
	
	def search_function
	  @sql = ""
    @terms.each do |term|
      @sql << "("
      @fields.each do |field|
        @sql << "#{field} ILIKE '%#{term}%' OR "
      end
      @sql = @sql[0..-4] << ") AND "
    end
    @sql = @sql[0..-5]
	end
	
	def complex_search_function
	  @sql = ""
    @terms.each do |term|
      @sql << "("
      @fields.each do |field|
        @sql << "#{field} ILIKE '%#{term}%' OR "
      end
      @tables.each do |table|
        @sql << fetch_from_side_table(table, term)
      end
      
      @sql = @sql[0..-4] << ") AND "
    end
    @sql = @sql[0..-5]
	end
  
end

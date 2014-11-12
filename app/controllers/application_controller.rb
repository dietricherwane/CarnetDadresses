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
	  if current_user.admin?
		  admin_dashboard_path
		else
		  if current_user.super_admin?
		    super_admin_dashboard_path
		  end
		end
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

	def fetch_from_side_table(table, term)
    results = eval(table[0]).where("name ILIKE '%#{term}%'")
    return results.blank? ? "" : "#{table[1]} IN #{results.map{|t| t.id}.to_s.sub('[', '(').sub(']', ')')} OR "
  end

	def authenticate_user_from_token!(authentication_token)
	  user = User.find_by_authentication_token(authentication_token)

	  if Devise.secure_compare((user.authentication_token rescue nil), authentication_token)
	    true
	  else
	    render json: "[" << {errors: "Vous n'avez pas pu être authentifié."}.to_json.to_s << "]"
	  end
	end

  def api_render_several_objects(my_objects, fields_to_merge, fields_to_except)
    my_hash = "{"'"data"'":["
    unless my_objects.empty?
	    my_objects.each do |my_object|
        my_hash << my_object.merge(fields_to_merge).except!(*fields_to_except).to_json << ","
      end
      my_hash = my_hash[0..(my_hash.length - 2)]
    end
    my_hash << "]}"

    return my_hash
	end

	def api_render_several_merged_objects(my_objects, fields_to_except, controller_name, method_name)
    my_hash = "{"'"data"'":["
    unless my_objects.empty?
	    my_objects.each do |my_object|
        my_hash << my_object.merge(controller_name.send :"#{method_name}", my_object).except!(*fields_to_except).to_json << ","
      end
      my_hash = my_hash[0..(my_hash.length - 2)]
    end
    my_hash << "]}"

    return my_hash
	end

	def api_render_object(my_object, fields_to_merge, fields_to_except)
	  if my_object
      my_hash = "{"'"data"'":[" << my_object.except!(*fields_to_except).to_json << "]}"
    else
      my_hash = "{"'"data"'":[]}"
    end

    return my_hash
	end

  def api_render_merged_object(my_object, fields_to_except, controller_name, method_name)
	  if my_object != nil
      my_hash = "{"'"data"'":[" << my_object.as_json.merge(controller_name.send :"#{method_name}", my_object).except!(*fields_to_except).to_json << "]}"
    else
      my_hash = "{"'"data"'":[]}"
    end

    return my_hash
	end
end

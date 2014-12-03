class LastUpdatesController < ApplicationController

  def api_last_updates
    last_updates = LastUpdate.all.limit(10).as_json
    my_hash = api_render_several_merged_objects(last_updates, api_fields_to_except, LastUpdatesController, "api_additional_fields_to_merge")

    render json: my_hash
  end

  def api_additional_fields_to_merge(last_update)
    return {name: "#{(AdressBook.find_by_id(last_update["user_id"]).full_name rescue '')}", company: "#{(Company.find_by_id(last_update['company_id']).name rescue '')}"}
  end

  def self.api_additional_fields_to_merge(last_update)
    return {name: "#{(AdressBook.find_by_id(last_update["user_id"]).full_name rescue '')}", company: "#{(Company.find_by_id(last_update['company_id']).name rescue '')}"}
  end

  def api_fields_to_except
    return ["user_id", "update_type_id", "firstname", "lastname", "company_name", "email", "phone_number", "mobile_number", "profile_id", "social_status_id", "trading_identifier", "created_by", "published", "sector_id", "sales_area_id", "new_firstname", "new_lastname", "new_company_name", "new_email", "new_phone_number", "new_mobile_number", "new_profile_id", "new_social_status_id", "new_trading_identifier", "new_created_by", "new_published", "new_sector_id", "new_sales_area_id", "comment", "new_comment"]
  end

  def self.api_fields_to_except
    return ["user_id", "update_type_id", "firstname", "lastname", "company_name", "email", "phone_number", "mobile_number", "profile_id", "social_status_id", "trading_identifier", "created_by", "published", "sector_id", "sales_area_id", "new_firstname", "new_lastname", "new_company_name", "new_email", "new_phone_number", "new_mobile_number", "new_profile_id", "new_social_status_id", "new_trading_identifier", "new_created_by", "new_published", "new_sector_id", "new_sales_area_id", "comment", "new_comment"]
  end
end

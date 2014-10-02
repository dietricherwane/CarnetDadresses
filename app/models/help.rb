class Help < ActiveRecord::Base
 
  attr_accessible :website_content, :website_updated_at, :website_user_id, :wallet_content, :wallet_updated_at, :wallet_user_id
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :website_content => "L'Aide du site web",
    :wallet_content => "L'Aide du wallet"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
end

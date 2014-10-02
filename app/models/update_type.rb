class UpdateType < ActiveRecord::Base 
  # Relationships
  has_many :last_updates
  
  attr_accessible :name, :user_id, :published
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Le type de mise à jour",   
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :name, :user_id, presence: true
  validates :name, uniqueness: true
  
  # Custom functions
  def self.create_type_id
    return UpdateType.find_by_name("create").id rescue nil
  end
  
  def self.update_type_id
    return UpdateType.find_by_name("update").id rescue nil
  end
end

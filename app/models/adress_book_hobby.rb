class AdressBookHobby < ActiveRecord::Base
  # Relationships
  belongs_to :adress_book
  belongs_to :hobby
  belongs_to :user
  
  attr_accessible :adress_book_id, :hobby_id, :user_id, :published
  
  # Scopes
  #default_scope {order("formation_year DESC")}
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :hobby_id => "Hobby"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  #Validations
  validates :adress_book_id, :hobby_id, :user_id, presence: true
  validates :hobby_id, uniqueness: {scope: :adress_book_id}
  
  # Custom functions
  def published?
    return published != false ? true : false
  end
end

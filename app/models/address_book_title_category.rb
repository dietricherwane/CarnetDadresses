class AddressBookTitleCategory < ActiveRecord::Base
  # Relationships
  has_many :address_book_titles
  
  # Scopes
  default_scope {order("name ASC")}
  
  attr_accessible :name, :published
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Nom"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true
end

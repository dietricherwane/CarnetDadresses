class AddressBookTitle < ActiveRecord::Base
  # Relationships
  has_many :adress_books
  belongs_to :address_book_title_category
  
  # Scopes
  default_scope {order("name ASC")}
  
  attr_accessible :name, :published, :address_book_title_category_id
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Nom"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :name, :address_book_title_category_id, presence: true
  validates :name, uniqueness: {scope: :address_book_title_category_id}
end

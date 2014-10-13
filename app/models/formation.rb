class Formation < ActiveRecord::Base
  include StringUtils
  
  # Relationships
  belongs_to :adress_book
  belongs_to :user
  
  attr_accessible :formation_year, :school, :diploma, :adress_book_id, :user_id, :published
  
  # Scopes
  default_scope {order("formation_year DESC")}
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :formation_year => "L'année", 
    :school => "L'école ou université",
    :diploma => "Le diplôme obtenu" 
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :formation_year, :school, :diploma, :adress_book_id, presence: true
  
  # Custom functions
  def short_diploma
    return "#{diploma[0..30]} #{diploma.length > 30 ? '...' : ''}"
  end
  
  def published?
    return published != false ? true : false
  end
end

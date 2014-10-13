class Membership < ActiveRecord::Base 
  # Relationships
  has_many :job_experiences
  
  attr_accessible :name, :published
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Le nom"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true
end

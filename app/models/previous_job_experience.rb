class PreviousJobExperience < ActiveRecord::Base
  # Relationships
  belongs_to :memberships
  belongs_to :user
  
  attr_accessible :begin_date, :end_date, :company_name, :role, :membership_id, :published
  
  # Scopes
  default_scope {order("end_date DESC")}
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :begin_date => "Début",
    :end_date => "Fin",
    :company_name => "Entreprise",
    :role => "Fonction",
    :membership_id => "Au sein de votre société vous êtes membre du"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :begin_date, :end_date, :company, :role, :membership_id, presence: true 
  
  # Custom functions
  def published?
    return published != false ? true : false
  end
end

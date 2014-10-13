class SocialStatus < ActiveRecord::Base
  # Modèle pour l'enregistrement des  domaines de vente relatifs aux entreprises côtées
  include StringUtils
  
  # Relationships
  has_many :users
  belongs_to :user
  
  attr_accessible :name, :user_id, :published
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "La raison sociale",   
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :name, :user_id, presence: true
  validates :name, uniqueness: true
  
  # Callbacks
  before_save :format_fields
  before_update :format_fields
  
  protected 
  def format_fields
    self.name = StringUtils.first_letter_uppercase(self.name)
  end
end

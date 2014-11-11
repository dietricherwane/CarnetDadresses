# Modèle pour l'enregistrement des  domaines de vente relatifs aux entreprises côtées

class SalesArea < ActiveRecord::Base
  include StringUtils

  # Relationships
  has_many :users
  belongs_to :user
  has_many :companies
  has_many :sub_sales_areas
  has_many :forum_themes

  attr_accessible :name, :user_id, :published, :created_at

  # Scopes
  default_scope order("name ASC")

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Le domaine d'activité",
    :user_id => "Créé par"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, :user_id, presence: true
  validates :name, uniqueness: true

  # Custom functions
  def published?
    return published != false ? true : false
  end
end

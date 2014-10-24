class Registration < ActiveRecord::Base
  # Relationships
  belongs_to :user

  attr_accessible :user_id, :created_at, :expires_at, :created_by, :published, :unpublished_by, :unpublished_at, :transaction_id

  # Scopes
  default_scope {order("created_at DESC")}

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :expires_at => "Expire le",
    :created_by => "Créé par",
    :created_at => "Créé le",
    :unpublished_by => "Désactivé par",
    :unpublished_at => "Désactivé le",
    :transaction_id => "Le numéro de transaction"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :expires_at, :created_by, :user_id, :transaction_id, presence: true
  validates :transaction_id, uniqueness: true

  # Custom functions
  def published?
    return published != false ? true : false
  end
end

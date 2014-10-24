class ForumPost < ActiveRecord::Base
  # Relationships
  belongs_to :forum_themes
  belongs_to :user

  # Scopes
  default_scope {order("created_at DESC")}

  attr_accessible :comment, :user_id, :created_at, :published, :unpublished_by, :unpublished_at, :updated_at, :forum_themes_id

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :comment => "Commentaire",
    :user_id => "Posté par",
    :created_at => "Posté le",
    :unpublished_by => "Désactivé par",
    :unpublished_at => "Désactivé le",
    :updated_at => "Mis à jour le"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :comment, :user_id, presence: true

  # Custom functions
  def published?
    return published != false ? true : false
  end
end

class NewsFeed < ActiveRecord::Base
  attr_accessible :title, :content, :publication_date, :published, :user_id, :created_at

  # Relationships
  belongs_to :user

  # Scopes
  default_scope order("published ASC, publication_date DESC, title ASC")

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :title => "Le titre",
    :content => "Le contenu",
    :publication_date => "La date de publication",
    :user_id => "L'auteur",
    :picture => "L'image",
    :created_by => "Créé par"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates :title, :content, :publication_date, :user_id, presence: true
  validates :title, :content, length: {minimum: 5}
  validates :title, :content, uniqueness: true

  # Custom functions
  def published?
    return published != false ? true : false
  end

end

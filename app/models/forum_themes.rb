class ForumThemes < ActiveRecord::Base
  # Relationships
  has_many :forum_posts
  belongs_to :user
  belongs_to :sales_area
  belongs_to :sub_sales_area

  # Scopes
  default_scope {order("created_at DESC")}

  attr_accessible :title, :content, :user_id, :validated_by, :validated_at, :unpublished_by, :unpublished_at, :created_at, :published, :sub_sales_area_id, :sales_area_id, :job_category

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :title => "Titre",
    :content => "Contenu",
    :user_id => "Posté par",
    :created_at => "Posté le",
    :validated_by => "Validé par",
    :validated_at => "Validé le",
    :unpublished_by => "Désactivé par",
    :unpublished_at => "Désactivé le",
    :sales_area_id => "Domaine d'activités",
    :sub_sales_area_id => "Sous domaine d'activités",
    :job_category => "Catégorie professionnelle"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :title, :content, :user_id, :sales_area_id, presence: true

  # Custom functions
  def published?
    return published != false ? true : false
  end
end

class SubSalesArea < ActiveRecord::Base
  # Relationships
  has_many :companies
  belongs_to :sales_area
  has_many :forum_themes

  # Scopes
  default_scope {order("name ASC")}

  attr_accessible :name, :published, :sales_area_id

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Nom"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, :sales_area_id, presence: true
  validates :name, uniqueness: {scope: :sales_area_id}
end

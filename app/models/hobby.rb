class Hobby < ActiveRecord::Base
  # Relationships
  has_many :adress_book_hobbies
  has_many :adress_books, through: :adress_book_hobbies

  attr_accessible :name, :published, :hobby_id, :user_id

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

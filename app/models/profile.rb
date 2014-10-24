# Modèle pour la gestion des  profils

class Profile < ActiveRecord::Base
  include StringUtils

  # Relationships
  has_many :users
  has_many :last_updates

  attr_accessible :name, :shortcut, :published

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "Le nom",
    :shortcut => "L'abbréviation"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :name, :shortcut, presence: true
  validates :name, :shortcut, uniqueness: true
  validates :shortcut, length: {maximum: 5}
  validates :name, length: {maximum: 50}

  # Custom functions
  def person?
    return shortcut == "DEC" ? true : false
  end

  def self.person_id
    return Profile.find_by_shortcut("DEC").id rescue nil
  end

  def self.company_id
    return Profile.find_by_shortcut("ENT").id rescue nil
  end

  def self.admin_id
    return Profile.find_by_shortcut("ADM").id rescue nil
  end

  def self.user_id
    return Profile.find_by_shortcut("UTI").id rescue nil
  end

  # Callbacks
  before_save :class_utils
  before_update :class_utils

  protected
  def class_utils
    self.shortcut = self.shortcut.strip.upcase
    self.name = StringUtils.first_letter_uppercase(self.name.strip)
  end
end

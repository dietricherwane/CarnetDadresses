class AdressBook < ActiveRecord::Base
  include StringUtils  
  
  # Relationships
  belongs_to :profile
  belongs_to :social_status
  has_many :social_statuses
  has_many :sales_areas
  belongs_to :sales_area
  belongs_to :sector

  
  # Scopes
  default_scope order("created_at DESC")
         
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :email => "L'email",
    :firstname => "Le nom",
    :lastname => "Le prénom",
    :phone_number => "Le numéro de téléphone fixe",
    :mobile_number => "Le numéro de téléphone mobile",
    :profile_id => "Le profil",
    :social_status_id => "Le type d'entreprise",
    :sector_id => "Le secteur d'opération",
    :sales_area_id => "Le domaine d'activité",
    :trading_identifier => "Le régistre de commerce",
    :company_name => "Le nom de l'entreprise",
    :comment => "Commentaire"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
         
  attr_accessible :email, :firstname, :lastname, :phone_number, :mobile_number, :profile_id, :published, :social_status_id, :trading_identifier, :company_name, :created_by, :sector_id, :sales_area_id, :comment
  
  # Validations
  validates :firstname, :lastname, :mobile_number, presence: true, unless: :company?
  validates :firstname, :lastname, :company_name, length: {in: 2..50, allow_blank: true}
  validates :email, :profile_id, :created_by, :sales_area_id, :sector_id, presence: true
  validates :company_name, :phone_number, presence: true, if: :company?
  #validates :social_status_id, :trading_identifier, :company_name, :sector_id, :sales_area_id, presence: true, if: :company?
  
  validates :phone_number, :mobile_number, :trading_identifier, length: {in: 6..15, allow_blank: true}
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true}
  validates :email, uniqueness: true
  
  # Utils
  def full_name
    #return "<b>[#{Profile.find_by_id(profile_id).shortcut}]</b> #{lastname} #{firstname}".html_safe
    return "<b>#{lastname} #{firstname}</b>".html_safe
  end
  
  def company_full_name
    return "<b>#{company_name}</b>".html_safe
  end
  
  def published?
    return published != false ? true : false
  end
  
  # Functions related to validations
  def company?
    Profile.find_by_name('Entreprise').id == profile_id.to_i rescue false
  end
  
  # Callbacks
  before_save :format_fields
  before_update :format_fields
  
  private
  def format_fields
    self.firstname = StringUtils.every_first_letter_uppercase(self.firstname)
    self.lastname = StringUtils.every_first_letter_uppercase(self.lastname)
    self.company_name = StringUtils.first_letter_uppercase(self.company_name.strip)
    self.trading_identifier = self.trading_identifier.upcase
  end
end

class AdressBook < ActiveRecord::Base
  include StringUtils  
  
  # Paperclip
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  # Relationships
  belongs_to :profile
  belongs_to :social_status
  has_many :social_statuses
  has_many :sales_areas
  belongs_to :sales_area
  belongs_to :sector
  has_many :job_experiences
  has_many :formations
  belongs_to :civility
  belongs_to :marital_status
  belongs_to :country
  belongs_to :holding
  belongs_to :address_book_title
  belongs_to :company

  
  # Scopes
  default_scope {order("created_at DESC")}
         
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :email => "Email",
    :firstname => "Le nom",
    :lastname => "Le prénom",
    :phone_number => "Téléphone",
    :mobile_number => "Le numéro de téléphone mobile",
    :profile_id => "Le profil",
    :social_status_id => "Forme juridique",
    :sector_id => "Votre catégorie",
    :sales_area_id => "Votre secteur d'activités",
    :trading_identifier => "N° RCC",
    :company_name => "Raison sociale",
    :company_id => "Entreprise",
    :comment => "Parcours",
    :civility_id => "Civilité",
    :birthdate => "Date de naissance",
    :marital_status_id => "Statut matrimonial",
    :childrens => "Le nombre d'enfants",
    :job_role => "La fonction occupée",
    :country_id => "Pays",
    :city => "Ville",
    :geographical_address => "Adresse géographique",
    :postal_address => "Adresse postale",
    :company_shortcut => "Sigle",
    :capital => "Capital (FCFA)",
    :employees_amount => "Nombre d'employés",
    :turnover => "Chiffre d'affaires",
    :holding_id => "Filiale d'un groupe",
    :activities => "Description de l'activité",
    :fax => "Fax",
    :website => "Site internet",
    :address_book_title_id => "Titre",
    :avatar => "Choisissez votre photo"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
         
  attr_accessible :email, :firstname, :lastname, :phone_number, :mobile_number, :profile_id, :published, :social_status_id, :trading_identifier, :company_name, :created_by, :sector_id, :sales_area_id, :comment, :civility_id, :birthdate, :marital_status_id, :childrens, :hobbies, :job_role, :geographical_address, :postal_address, :city, :country_id, :company_shortcut, :capital, :employees_amount, :turnover, :holding_id, :activities, :fax, :website, :address_book_title_id, :company_id, :avatar
    
  # Validations
  validates :firstname, :lastname, :email, :civility_id, :birthdate, :marital_status_id, :childrens, :job_role, :city, :country_id, :comment, :company_id, presence: true, unless: :company?
  validates :firstname, :lastname, :company_name, length: {in: 2..50, allow_blank: true}
  validates :profile_id, :created_by, :sector_id, presence: true
  validates :company_name, :phone_number, :activities, :city, :country_id, :company_shortcut, :sales_area_id, :social_status_id, :trading_identifier, :fax, :geographical_address, :postal_address, presence: true, if: :company?
  validates :childrens, numericality: {greater_than: -1}, unless: :company?
  #validates :social_status_id, :trading_identifier, :company_name, :sector_id, :sales_area_id, presence: true, if: :company?
  
  validates :phone_number, :fax, :trading_identifier, length: {in: 6..15, allow_blank: true}
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true}
  validates :email, uniqueness: true
  validates :website, format: {with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, multiline: true, allow_blank: true}
  
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
    self.firstname = StringUtils.every_first_letter_uppercase(self.firstname) rescue nil
    self.lastname = StringUtils.every_first_letter_uppercase(self.lastname) rescue nil
    self.company_name = StringUtils.first_letter_uppercase(self.company_name) rescue nil
    self.trading_identifier = self.trading_identifier.upcase rescue nil
  end
end

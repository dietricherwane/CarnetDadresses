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
  belongs_to :sub_sales_area
  belongs_to :sector
  has_many :job_experiences
  has_many :formations
  belongs_to :civility
  belongs_to :marital_status
  belongs_to :country
  belongs_to :holding
  belongs_to :address_book_title
  belongs_to :company
  has_many :previous_job_experiences
  has_many :adress_book_hobbies
  has_many :hobbies, through: :adress_book_hobbies


  # Scopes
  default_scope {order("published ASC", "created_at DESC")}

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :email => "Email",
    :firstname => "Nom",
    :lastname => "Prénoms",
    :phone_number => "Téléphone",
    :profile_id => "Le profil",
    :sector_id => "Votre catégorie",
    :company_name => "Raison sociale",
    :company_id => "Entreprise",
    :comment => "Parcours",
    :civility_id => "Civilité",
    :birthdate => "Date de naissance",
    :marital_status_id => "Statut matrimonial",
    :childrens => "Nombre d'enfants",
    :job_role => "Fonction occupée",
    :country_id => "Pays",
    :city => "Ville",
    :geographical_address => "Adresse géographique",
    :postal_address => "Adresse postale",
    :address_book_title_id => "Titre",
    :avatar => "Choisissez votre photo"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  attr_accessible :email, :firstname, :lastname, :phone_number, :profile_id, :published, :company_name, :created_by, :sector_id, :comment, :civility_id, :birthdate, :marital_status_id, :childrens, :job_role, :geographical_address, :postal_address, :city, :country_id, :address_book_title_id, :company_id, :avatar

  # Validations
  #validates :firstname, :lastname, :email, :civility_id, :birthdate, :marital_status_id, :childrens, :job_role, :city, :country_id, :comment, :company_id, presence: true, unless: :company?
  validates :firstname, :lastname, :job_role, :company_id, presence: true
  validates :firstname, :lastname, :company_name, length: {in: 2..50, allow_blank: true}
  #validates :profile_id, :created_by, :sector_id, presence: true
  #validates :childrens, numericality: {greater_than: -1}, unless: :company?
  #validates :phone_number, length: {in: 6..15, allow_blank: true}
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true, allow_blank: true}
  #validates :email, uniqueness: true

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
  end
end

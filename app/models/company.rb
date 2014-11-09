class Company < ActiveRecord::Base
  include StringUtils

  # Paperclip
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  # Relationships
  belongs_to :social_status
  belongs_to :sales_area
  belongs_to :sub_sales_area
  belongs_to :sector
  has_many :adress_books
  belongs_to :country
  belongs_to :holding

  # Scopes
  default_scope {order("created_at DESC")}

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :email => "Email",
    :phone_number => "Téléphone",
    :social_status_id => "Forme juridique",
    :sector_id => "Votre catégorie",
    :sales_area_id => "Votre secteur d'activités",
    :trading_identifier => "N° RCC",
    :name => "Raison sociale",
    :comment => "Parcours",
    :civility_id => "Civilité",
    :country_id => "Pays",
    :city => "Ville",
    :geographical_address => "Adresse géographique",
    :postal_address => "Adresse postale",
    :shortcut => "Sigle",
    :capital => "Capital (Millions de FCFA)",
    :employees_amount => "Nombre d'employés",
    :turnover => "Chiffre d'affaires",
    :holding_id => "Filiale d'un groupe",
    :activities => "Description de l'activité",
    :fax => "Fax",
    :website => "Site internet",
    :logo => "Choisissez votre logo",
    :sub_sales_area_id => "Votre sous secteur d'activités"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  attr_accessible :email, :phone_number, :published, :social_status_id, :trading_identifier, :name, :created_by, :sector_id, :sales_area_id, :geographical_address, :postal_address, :city, :country_id, :shortcut, :capital, :employees_amount, :turnover, :holding_id, :activities, :fax, :website, :logo, :created_by, :validated_by, :sub_sales_area_id

  # Validations
  validates :created_by, :sector_id, presence: true
  validates :name, :phone_number, :activities, :city, :country_id, :shortcut, :sales_area_id, :social_status_id, :trading_identifier, :fax, :geographical_address, :postal_address, presence: true
  validates :phone_number, :fax, :trading_identifier, length: {in: 6..15, allow_blank: true}
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true, allow_blank: true}
  validates :email, uniqueness: {allow_blank: true}
  validates :name, uniqueness: {scope: :country_id}
  validates :website, format: {with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, multiline: true, allow_blank: true}

  def full_name
    return "<b>#{name}</b>".html_safe
  end

  def published?
    return published != false ? true : false
  end
end

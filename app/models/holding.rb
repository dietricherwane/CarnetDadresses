class Holding < ActiveRecord::Base
  # Relationships
  has_many :adress_books
  belongs_to :user
  belongs_to :country

  
  # Scopes
  default_scope {order("name ASC")}
         
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :name => "La raison sociale",
    :shortcut => "Le sigle",
    :number_of_companies => "Le nombre d'entreprises",
    :phone_number => "Le numéro de téléphone",
    :website => "Le site web",
    :email => "L'email",
    :geographical_address => "L'adresse géographique",
    :postal_address => "L'adresse postale",
    :country_id => "Le pays",
    :city => "La ville",
    :activities => "Le détail des activités"           
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
         
  attr_accessible :name, :shortcut, :number_of_companies, :phone_number, :website, :email, :geographical_address, :postal_address, :country_id, :city, :activities, :user_id, :created_at, :published
    
  # Validations
  validates :name, :number_of_companies, :phone_number, :country_id, :city, :geographical_address, :postal_address, :activities, :user_id, presence: true
  validates :name, uniqueness: true
  validates :number_of_companies, numericality: {greater_than: 0}
  validates :email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true, allow_blank: true}
  validates :website, format: {with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, multiline: true, allow_blank: true}
  
  # Custom functions
  def published?
    return published != false ? true : false
  end
end

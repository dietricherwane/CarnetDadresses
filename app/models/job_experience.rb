class JobExperience < ActiveRecord::Base
  include StringUtils
   
  # Relationships
  belongs_to :hiring_status
  belongs_to :hiring_type
  belongs_to :memberships
  belongs_to :adress_book
  belongs_to :user
  
  attr_accessible :begin_date, :end_date, :company, :team_members, :role, :membership_id, :phone_number, :email, :hiring_status_id, :missions, :hiring_type_id, :predecessor_firstname, :predecessor_lastname, :assistant_firstname, :assistant_lastname, :assistant_phone_number, :assistant_email, :superior_title, :superior_firstname, :superior_lastname, :misc, :adress_book_id, :user_id, :published, :created_at
  
  # Scopes
  default_scope {order("begin_date DESC")}
  
  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :begin_date => "Début",
    :end_date => "Fin",
    :company => "Entreprise",
    :team_members => "Effectif de votre équipe",
    :role => "Fonction",
    :membership_id => "Au sein de votre société vous êtes membre du",
    :phone_number => "Ligne directe",
    :email => "Email professionnel",
    :hiring_type_id => "Type d'embauche",
    :hiring_status_id => "Statut",
    :missions => "Missions et réalisations",
    :predecessor_firstname => "Nom du prédecesseur",
    :predecessor_lastname => "Prénom du prédecesseur",
    :assistant_firstname => "Nom de l'assistant(e)",
    :assistant_lastname => "Prénom de l'assistant(e)",
    :assistant_phone_number => "Ligne directe",
    :assistant_email => "Email",
    :superior_title => "Titre du supérieur",
    :superior_firstname => "Nom du supérieur",
    :superior_lastname => "Prénom du supérieur",
    :misc => "Informations diverses (pertinentes pour votre profil)"
  }
  
  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  # Validations
  validates :begin_date, :end_date, :company, :team_members, :role, :membership_id, :hiring_type_id, :hiring_status_id, :missions, :adress_book_id, presence: true
  validates :company, :email, :predecessor_firstname, :predecessor_lastname, :superior_title, :superior_firstname, :superior_lastname, length: {in: 2..100, allow_blank: true}
  validates :team_members, numericality: {minimum: 0}
  validates :phone_number, :assistant_phone_number, length: {in: 6..15, allow_blank: true}
  validates :email, :assistant_email, format: {with: /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i, multiline: true}  
  
  # Custom functions
  def published?
    return published != false ? true : false
  end
end

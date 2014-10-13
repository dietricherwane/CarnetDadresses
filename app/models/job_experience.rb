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
    :begin_date => "La date de début",
    :end_date => "La date de fin",
    :company => "Le nom de l'entreprise",
    :team_members => "Le nombre de membres de l'équipe",
    :role => "La fonction",
    :membership_id => "Vous étiez membre du",
    :phone_number => "Le numéro de téléphone",
    :email => "L'email",
    :hiring_type_id => "Le type de contrat",
    :hiring_status_id => "Le statut",
    :missions => "Les missions",
    :predecessor_firstname => "Le nom du prédecesseur",
    :predecessor_lastname => "Le prénom du prédecesseur",
    :assistant_firstname => "Le nom de l'assistant(e)",
    :assistant_lastname => "Le prénom de l'assistant(e)",
    :assistant_phone_number => "Le numéro de téléphone de l'assistant(e)",
    :assistant_email => "L'email de l'assistant(e)",
    :superior_title => "Le titre du supérieur",
    :superior_firstname => "Le nom du supérieur",
    :superior_lastname => "Le prénom du supérieur",
    :misc => "Informations_complémentaires"
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

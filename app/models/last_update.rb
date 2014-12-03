class LastUpdate < ActiveRecord::Base
  include StringUtils

  attr_accessible :email, :firstname, :lastname, :phone_number, :mobile_number, :profile_id, :published, :social_status_id, :trading_identifier, :company_name, :created_by, :sector_id, :sales_area_id, :comment, :new_email, :new_firstname, :new_lastname, :new_phone_number, :new_mobile_number, :new_profile_id, :new_published, :new_social_status_id, :new_trading_identifier, :new_company_name, :new_created_by, :new_sector_id, :new_sales_area_id, :new_comment, :created_at, :user_id, :update_type_id, :company_id

  # Relationships
  belongs_to :update_type
  belongs_to :user
  belongs_to :profile
  belongs_to :company

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
    :social_status_id => "La raison sociale",
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

  # Custom functions
  def update_status
    update_type.name == "create" ? "Création" : "Modification"
  end

  def update_entry_type
    profile.name
  end

  # Callbacks
  before_save :format_fields
  before_update :format_fields

  private
  def format_fields
    self.firstname = StringUtils.every_first_letter_uppercase(self.firstname) rescue nil
    self.lastname = StringUtils.every_first_letter_uppercase(self.lastname) rescue nil
    self.company_name = StringUtils.first_letter_uppercase(self.company_name.strip) rescue nil
    self.trading_identifier = self.trading_identifier.upcase rescue nil
  end
end

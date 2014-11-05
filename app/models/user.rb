# Modèle pour  l'enregistrement des utilisateurs  (entreprises financières, journalistes, analystes, vérificateurs, chefs analystes)

class User < ActiveRecord::Base
  include StringUtils

  # Relationships
  belongs_to :profile
  belongs_to :social_status
  has_many :social_statuses
  has_many :sales_areas
  belongs_to :sales_area
  belongs_to :sector
  has_many :last_updates
  has_many :news_feeds
  has_many :formations
  has_many :job_experiences
  has_many :previous_job_experiences
  has_many :adress_book_hobbies
  has_many :forum_themes
  has_many :forum_posts
  has_many :registrations

  # Scopes
  default_scope {order("created_at DESC")}

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :token_authenticatable#, :confirmable

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    :email => "L'email",
    :firstname => "Le nom",
    :lastname => "Le prénom",
    :phone_number => "Le numéro de téléphone fixe",
    :mobile_number => "Le numéro de téléphone mobile",
    :profile_id => "Le profil",
    :social_status_id => "La raison sociale",
    :trading_identifier => "Le régistre de commerce",
    :password => "Le mot de passe",
    :password_confirmation => "La confirmation de mot de passe",
    :company_name => "Le nom de l'entreprise",
    :role => "Fonction",
    :validated_by => "Activé par",
    :validated_at => "Activé le",
    :unpublished_by => "Désactivé par",
    :unpublished_at => "Désactivé le"
  }

  # Using friendly attribute name if it exists and default name otherwise
  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  attr_accessible :email, :firstname, :lastname, :phone_number, :mobile_number, :profile_id, :published, :social_status_id, :trading_identifier, :company_name, :created_by, :password, :password_confirmation, :confirmation_token, :sector_id, :sales_area_id, :comment, :role, :validated_by, :validated_at, :unpublished_by, :unpublished_at, :authentication_token

  # Validations
  validates :firstname, :lastname, presence: true
  validates :mobile_number, :profile_id, presence: true
  validates :firstname, :lastname, length: {in: 2..50}
  validates :phone_number, :mobile_number, length: {in: 6..15, allow_blank: true}

  # Utils
  def full_name
    return "</b>#{lastname} #{firstname}</b>".html_safe
  end

  def company_full_name
    return "<b>[#{Profile.find_by_id(profile_id).shortcut}]</b> #{company_name}".html_safe
  end

  def published?
    return published != false ? true : false
  end

  # Functions related to validations
  def company?
    Profile.find_by_name('Entreprise financière').id == profile_id.to_i rescue false
  end

  def admin?
    profile.name == "Administrateur"
  end

  def last_registration
    return registrations.where("expires_at > '#{Date.today}' AND published IS NOT FALSE").first
  end

  def self.authenticate(email, password)
      user = User.find_for_authentication(email: email)
      if user
        user = user.valid_password?(password) ? user : nil
      end
      return user
  end

  # Callbacks
  before_save :format_fields
  before_update :format_fields

  private
  def format_fields
    self.firstname = StringUtils.every_first_letter_uppercase(self.firstname)
    self.lastname = StringUtils.every_first_letter_uppercase(self.lastname)
  end
end

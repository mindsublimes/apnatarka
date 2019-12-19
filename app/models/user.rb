class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2], authentication_keys: [:login]
  has_many :orders
  has_many :addresses

  enum user_role: [:super_admin, :moderator_user, :normal_user]

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_presence_of :email
  validates_uniqueness_of :phone, unless: -> { from_omniauth? }

  user_roles.each do |k, v|
    define_method "#{k}?" do
      role == v
    end
  end

  def role_name
    User.user_roles.keys[role].titleize
  end

  def login=(login)
    @login = self.email
  end

  def login
    @login || self.phone || self.email
  end

  class << self

    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:phone) || conditions.has_key?(:email)
        where(conditions.to_hash).first
     end
    end

    def create_from_provider_data(provider_data)
      where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do | user |
        user.email = provider_data.info.email
        user.password = Devise.friendly_token[0, 20]
        user.first_name = provider_data.info.first_name
        user.last_name = provider_data.info.last_name
        user.skip_confirmation!
      end
    end

  end

  private

    def from_omniauth?
      provider && uid
    end

end
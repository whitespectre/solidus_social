class Spree::AuthenticationMethod < ActiveRecord::Base
  def self.provider_options
    SolidusSocial.configured_providers.map { |provider_name| [provider_name.split("_").first.camelize, provider_name] }
  end

  validates :provider, presence: true

  def self.active_authentication_methods?
    active.exists?
  end

  def self.envs
    [Rails.env]
  end

  scope :active, -> { where(environment: ::Rails.env, active: true) }

  scope :available_for, lambda { |user|
    sc = where(environment: ::Rails.env)
    sc = sc.where(['provider NOT IN (?)', user.user_authentications.map(&:provider)]) if user && !user.user_authentications.empty?
    sc
  }
end

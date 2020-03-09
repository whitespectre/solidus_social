# frozen_string_literal: true

module SolidusSocial
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.class_eval do
          has_many :user_authentications, dependent: :destroy

          devise :omniauthable
        end
      end

      def apply_omniauth(omniauth)
        if email.blank?
          if omniauth.fetch('info', {})['email'].present?
            self.email = omniauth['info']['email']
          else
            self.email = "#{signup_token}@#{ENV['BASE_DOMAIN']}"
          end
        end

        if omniauth.fetch('info', {})['name'].present?
          fname, lname = omniauth['info']['name'].split(' ')
          self.first_name = fname if first_name.blank?
          self.last_name = lname if last_name.blank? && lname.present?
        end

        # TODO: get user birthday

        user_authentications.find_or_initialize_by(provider: omniauth['provider'], uid: omniauth['uid'])
      end

      def password_required?
        (user_authentications.empty? || password.present?) && super
      end

      ::Spree.user_class.prepend self
    end
  end
end

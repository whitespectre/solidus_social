# frozen_string_literal: true

class Spree::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store
  include Rails.application.routes.url_helpers

  class << self
    def provides_callback_for(*providers)
      providers.each do |provider|
        define_method(provider) { omniauth_callback }
      end
    end
  end

  Spree::SocialConfig.providers.keys.each do |provider|
    provides_callback_for provider
  end

  def omniauth_callback
    if request.env['omniauth.error'].present?
      flash[:error] = I18n.t('devise.omniauth_callbacks.failure', kind: auth_hash['provider'], reason: I18n.t('spree.user_was_not_valid'))
      redirect_back_or_default(root_url)
      return
    end

    authentication = Spree::UserAuthentication.find_by(provider: auth_hash['provider'], uid: auth_hash['uid'])
    session[:oauth_provider] = auth_hash['provider']

    if authentication.present? && authentication.try(:user).present?
      user = authentication.user
      if user.dsr?
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: auth_hash['provider'])
        sign_in_and_redirect :spree_user, user
      else
        # make sure signup_cookie equal existing user token
        set_signup_token_cookie(user.signup_token)

        redirect_to signup_url(subdomain: ENV['OFFICE_DOMAIN'])
      end
    elsif spree_current_user
      redirect_back_or_default(root_url)
    else
      # new authentication

      email = auth_hash['info']['email']
      existing_user = Spree.user_class.find_by_email(email)
      if existing_user && existing_user.dsr?
        flash[:error] = I18n.t('devise.omniauth_callbacks.existing_dsr', email: email, dsr: I18n.t('app.dsr'))
        redirect_to dsr_login_url(subdomain: ENV['OFFICE_DOMAIN'])
      elsif existing_user
        # make sure signup_cookie equal existing user token
        set_signup_token_cookie(existing_user.signup_token)

        # populate user info
        existing_user.apply_omniauth(auth_hash)
        existing_user.save
        existing_user.next_step! if existing_user.in_progress?

        redirect_to signup_url(subdomain: ENV['OFFICE_DOMAIN'])
      else
        user = generate_new_user(set_signup_token)

        # populate user info
        user.apply_omniauth(auth_hash)
        user.save
        user.next_step! if user.in_progress?

        redirect_to signup_url(subdomain: ENV['OFFICE_DOMAIN'])
      end
    end
  end

  def failure
    set_flash_message :error, :failure, kind: failed_strategy.name.to_s.humanize, reason: failure_message
    redirect_to spree.login_path
  end

  def passthru
    render file: "#{Rails.root}/public/404.html", formats: [:html], status: :not_found, layout: false
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  private

  def set_signup_token
    cookies[:signup_token].presence ||
      set_signup_token_cookie(SecureRandom.hex)
  end

  def set_signup_token_cookie(token)
    cookies.permanent[:signup_token] = { value: token, domain: ENV['BASE_DOMAIN'] }
    token
  end

  def generate_new_user(token)
    Spree::User.find_or_init_by_token(token)
  end
end

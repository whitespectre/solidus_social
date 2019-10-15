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

    authentication = Spree::UserAuthentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])
    session[:oauth_provider] = auth_hash['provider']

    clubhouse = request.subdomain == 'clubhouse'

    if authentication.present? and authentication.try(:user).present?
      user = authentication.user
      if user.partner?
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: auth_hash['provider'])
        sign_in_and_redirect :spree_user, user
      else
        if clubhouse
          # make sure signup_cookie equal existing user token
          set_signup_token_cookie(user.signup_token)

          redirect_to signup_url(subdomain: 'clubhouse')
        else
          redirect_to root_url(subdomain: 'www')
        end
      end
    elsif spree_current_user
      redirect_back_or_default(root_url)
    else
      # new authentication

      email = auth_hash['info']['email']
      existing_user = Spree.user_class.find_by_email(email)
      if clubhouse
        if existing_user && existing_user.partner?
          flash[:error] = I18n.t('devise.omniauth_callbacks.existing_partner', email: email)
          redirect_to partner_login_url(subdomain: 'clubhouse')
        elsif existing_user
          # make sure signup_cookie equal existing user token
          set_signup_token_cookie(existing_user.signup_token)

          # populate user info
          existing_user.apply_omniauth(auth_hash)
          existing_user.save
          existing_user.next_step! if existing_user.in_progress?

          redirect_to signup_url(subdomain: 'clubhouse')
        else
          user = generate_new_user(set_signup_token)

          # populate user info
          user.apply_omniauth(auth_hash)
          user.save
          user.next_step! if user.in_progress?

          redirect_to signup_url(subdomain: 'clubhouse')
        end
      else
        Rails.logger.info("-------")
        Rails.logger.info(email)
        redirect_to root_url(subdomain: 'www')

        # if existing_user && existing_user.customer?
        # elsif existing_user
        # else
        # end
      end
    end
  end

  def failure
    set_flash_message :error, :failure, kind: failed_strategy.name.to_s.humanize, reason: failure_message
    redirect_to spree.login_path
  end

  def passthru
    render file: "#{Rails.root}/public/404", formats: [:html], status: 404, layout: false
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  private

  def set_signup_token
    cookies[:signup_token2].presence ||
      set_signup_token_cookie(SecureRandom.hex)
  end

  def set_signup_token_cookie(token)
    cookies.permanent[:signup_token2] = { value: token, domain: ENV['BASE_DOMAIN'] }
    token
  end

  def generate_new_user(token)
    Spree::User.find_or_init_by_token(token)
  end
end

Spree.user_class.class_eval do
  has_many :user_authentications, dependent: :destroy

  devise :omniauthable

  def apply_omniauth(omniauth)
    if omniauth.fetch('info', {})['email'].present?
      self.email = omniauth['info']['email'] if email.blank?
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
    (user_authentications.empty? || !password.blank?) && super
  end
end

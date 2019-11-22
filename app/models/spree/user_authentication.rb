# frozen_string_literal: true

class Spree::UserAuthentication < ApplicationRecord
  belongs_to :user
end

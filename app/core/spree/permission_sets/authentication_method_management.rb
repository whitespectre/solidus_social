# frozen_string_literal: true

module Spree
  module PermissionSets
    class AuthenticationMethodManagement < PermissionSets::Base
      def activate!
        can :manage, Spree::AuthenticationMethod
      end
    end
  end
end

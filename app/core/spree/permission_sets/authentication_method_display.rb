# frozen_string_literal: true

module Spree
  module PermissionSets
    class AuthenticationMethodDisplay < PermissionSets::Base
      def activate!
        can [:display, :admin], Spree::AuthenticationMethod
      end
    end
  end
end

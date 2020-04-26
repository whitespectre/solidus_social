# frozen_string_literal: true

Deface::Override.new(virtual_path: 'spree/admin/shared/_configuration_menu',
                     name: 'add_social_providers_link_configuration_menu',
                     insert_bottom: '[data-hook="admin_configurations_sidebar_menu"]',
                     disabled: false) do
                       <<-HTML
                        <% if can? :admin, Spree::AuthenticationMethod %>
                          <%= configurations_sidebar_menu_item I18n.t("spree.social_authentication_methods"), spree.admin_authentication_methods_path %>
                        <% end %>
                        HTML
                     end

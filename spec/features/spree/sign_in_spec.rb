# frozen_string_literal: true

RSpec.describe 'Signing in using Omniauth', :js do
  context 'facebook' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'facebook',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.mock_auth[:facebook] = {
        'provider' => 'facebook',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'email' => 'mockuser@example.com',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end

    it 'going to sign in' do
      visit spree.login_path
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
      click_link 'Logout'
      click_link 'Login'
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
    end

    # Regression test for #91
    it "attempting to view 'My Account' works" do
      visit spree.login_path
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
      click_link 'My Account'
      expect(page).to have_text 'My Account'
    end

    it "view 'My Account'" do
      visit spree.login_path
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
      click_link 'My Account'
      expect(page).not_to have_selector 'div#social-signin-links'
    end
  end

  context 'twitter' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'twitter',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = {
        'provider' => 'twitter',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end

    it 'going to sign in' do
      visit spree.login_path
      click_on 'Login with twitter'
      expect(page).to have_text 'Please confirm your email address to continue'.upcase
      fill_in 'Email', with: 'user@example.com'
      click_button 'Create'
      expect(page).to have_text 'Welcome! You have signed up successfully.'
    end
  end
end

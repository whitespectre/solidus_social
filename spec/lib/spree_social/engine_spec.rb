RSpec.describe SolidusSocial do
  describe '.configured_providers' do
    subject { described_class.configured_providers }

    it { is_expected.to match_array(["amazon", "facebook", "github", "google_oauth2", "twitter"]) }
  end

  describe '.init_providers' do
    subject { described_class.init_providers }

    around do |example|
      previous_providers = Spree::SocialConfig.providers
      Spree::SocialConfig.providers = { facebook: { api_key: "secret_key", api_secret: "secret_secret" } }
      example.run
      Spree::SocialConfig.providers = previous_providers
    end

    it "sets up Devise for the given providers" do
      expect(SolidusSocial).to receive(:setup_key_for).with(:facebook, "secret_key", "secret_secret")
      subject
    end
  end

  context 'constants' do
    it { is_expected.to be_const_defined(:OAUTH_PROVIDERS) }

    it 'contain all providers' do
      oauth_providers = [
        %w(Amazon amazon),
        %w(Facebook facebook),
        %w(Twitter twitter),
        %w(Github github),
        %w(Google google_oauth2)
      ]
      expect(described_class::OAUTH_PROVIDERS).to match_array oauth_providers
    end
  end
end

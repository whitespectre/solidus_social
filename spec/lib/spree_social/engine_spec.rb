RSpec.describe SolidusSocial do
  describe '.configured_providers' do
    subject { described_class.configured_providers }

    it { is_expected.to match_array(["amazon", "facebook", "github", "google_oauth2", "twitter"]) }
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

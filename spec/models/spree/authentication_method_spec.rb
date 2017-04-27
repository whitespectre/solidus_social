RSpec.describe Spree::AuthenticationMethod do
  describe '.provider_options' do
    let(:expected_provider_options) do
      [
        %w(Amazon amazon),
        %w(Facebook facebook),
        %w(Twitter twitter),
        %w(Github github),
        %w(Google google_oauth2)
      ]
    end

    subject { described_class.provider_options }

    it { is_expected.to match_array(expected_provider_options) }
  end
end

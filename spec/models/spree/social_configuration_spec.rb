RSpec.describe Spree::SocialConfiguration do
  it { is_expected.to respond_to(:path_prefix) }
  it { is_expected.to respond_to(:providers) }
end

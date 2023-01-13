# frozen_string_literal: true

RSpec.describe Spree::SocialConfig do
  it "changing a preference does not create a Spree::Preference" do
    expect { subject.path_prefix = 'customer' }.not_to change(Spree::Preference, :count)
  end

  it "holds configuration for default providers" do
    providers = %i[facebook github google_oauth2 twitter2]
    expect(subject.providers.keys).to match_array(providers)
  end
end

require 'rails_helper'

RSpec.describe Cwa::GenerateUrl do
  let(:company) { FactoryBot.create(:company, name: "Example Inc", location_type: :public_building, street: "Example Str. 2", zip: "10223", city: "Berlin", cwa_crypto_seed: "\x9E\x1C\x85\xDDq WL}C\xD8\xDA?\xB7ih") }

  context 'happy path' do
    subject { -> { described_class.call(company: company) } }

    it 'Runs without errors' do
      expect(subject.call.success?).to be(true)
    end

    it "accepts the data request" do
      url = subject.call.url
      expect(url).to eql("https://e.coronawarn.app?v=1#CAESLQgBEgtFeGFtcGxlIEluYxocRXhhbXBsZSBTdHIuIDIsIDEwMjIzIEJlcmxpbhqXAQgBEoABZ3dMTXpFMTUzdFF3QU9mMk1ab1VYWGZ6V1RkbFNwZlM5OWlaZmZtY214T0c5bmpTSzRSVGltRk9Gd0RoNnQwVHl3OFhSMDF1Z0RZanR1S3dqanVLNDlPaDgzRldjdDZYcGVmUGk5U2tqeHZ2ejUzaTlnYU1tVUVjOTZwYnRvYUEaEJ4chd1xIFdMfUPY2j-3aWgiBwgBEAgY8AE=")
    end
  end
end
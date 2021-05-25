require 'rails_helper'
require 'climate_control'

RSpec.describe Affiliate do
  describe 'Setup link should be generated' do
    let(:affiliate) { FactoryBot.create(:affiliate) }

    it 'should generate a setup link even if the env is empty' do
      expect(affiliate.link).to eql("/business/setup/intro?affiliate=#{affiliate.code}")
    end

    it 'should remove the backslash at the end' do
      ClimateControl.modify FRONTEND_URL: "https://localhost/path/" do
        expect(affiliate.link).to eql("https://localhost/path/business/setup/intro?affiliate=#{affiliate.code}")
      end
    end

    it 'should keep the url correct if there is no trailing backslash' do
      ClimateControl.modify FRONTEND_URL: "https://localhost/path/" do
        expect(affiliate.link).to eql("https://localhost/path/business/setup/intro?affiliate=#{affiliate.code}")
      end
    end
  end
end

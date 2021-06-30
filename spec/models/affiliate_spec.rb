require 'rails_helper'
require 'climate_control'

RSpec.describe Affiliate do
  describe 'Setup link should be generated' do
    let(:affiliate) { FactoryBot.create(:affiliate) }

    it 'should generate a setup link even if the env is empty' do
      expect(affiliate.link).to eql("/business/setup/intro?affiliate=#{affiliate.code}")
    end

    it 'should remove the slash at the end' do
      ClimateControl.modify FRONTEND_URL: "https://localhost/path/" do
        expect(affiliate.link).to eql("https://localhost/path/business/setup/intro?affiliate=#{affiliate.code}")
      end
    end

    it 'should keep the url correct if there is no trailing slash' do
      ClimateControl.modify FRONTEND_URL: "https://localhost/path/" do
        expect(affiliate.link).to eql("https://localhost/path/business/setup/intro?affiliate=#{affiliate.code}")
      end
    end
  end

  describe "owner_count" do
    let(:affiliate) { FactoryBot.create(:affiliate) }

    it "should return the correct owner count" do
      FactoryBot.create(:owner, affiliate: affiliate.code)
      FactoryBot.create(:owner, affiliate: affiliate.code)
      FactoryBot.create(:owner)

      expect(affiliate.owner_count).to eql 2
    end
  end

  describe "company_count" do
    let(:affiliate) { FactoryBot.create(:affiliate) }

    it "should return the correct owner count" do
      owner1 = FactoryBot.create(:owner, affiliate: affiliate.code)
      owner2 = FactoryBot.create(:owner, affiliate: affiliate.code)
      FactoryBot.create(:company, owner: owner1)
      FactoryBot.create(:company, owner: owner1)
      FactoryBot.create(:company, owner: owner2)
      FactoryBot.create(:company)

      expect(affiliate.company_count).to eql 3
    end
  end
end

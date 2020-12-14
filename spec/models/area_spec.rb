require 'rails_helper'

RSpec.describe Area do
  describe 'checkin link should be generated' do
    let(:company) { FactoryBot.create(:company) }
    let(:area) { FactoryBot.create(:area, company: company) }

    it 'should generate a checkin link' do
      expect(area.checkin_link).to be_a(URI)
    end
  end
end

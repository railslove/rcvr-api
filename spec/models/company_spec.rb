require 'rails_helper'

RSpec.describe Company do
  describe '.menu_pdf' do
    let(:company) { FactoryBot.create(:company) }

    context "Link handling" do
      it 'should return an empty link by default' do
        expect(company.menu_pdf_link).to be_nil
      end

      it 'should return a link after attaching a file' do
        company.menu_pdf.attach(io: File.open(__FILE__), filename: 'menu.pdf', content_type: 'application/pdf')
        expect(company.menu_pdf_link).to be_a(String)
      end
    end

    it 'should delete the menu when requested' do
      company.menu_pdf.attach(io: File.open(__FILE__), filename: 'menu.pdf', content_type: 'application/pdf')
      expect { company.update!({:remove_menu_pdf => '1'}) }
        .to change { company.menu_pdf.blank? }.from(false).to(true)
        .and change { company.menu_pdf_link }.to(nil)
    end

    it 'should generate an address string' do
      expect(company.address).to eql("#{company.street}, #{company.zip} #{company.city}")
    end

  end

  describe "affiliate=" do
    it 'should update the affiliate code in the owner' do
      company = FactoryBot.create(:company)
      company.affiliate = "awesome-code"
      expect(company.owner.affiliate).to eql("awesome-code")
    end
  end
end

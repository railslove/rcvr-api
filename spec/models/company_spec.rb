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
      expect(company.menu_pdf.blank?).to be false
      company.update!({:remove_menu_pdf => '1'})
      expect(company.menu_pdf.blank?).to be true
      expect(company.menu_pdf_link).to be_nil
    end
  end
end

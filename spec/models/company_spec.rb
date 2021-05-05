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

    it 'should generate a cwa_crypto_seed' do
      expect(company.cwa_crypto_seed).not_to be_nil
    end

    it 'should not update the crypto after an update' do
      old_seed = company.cwa_crypto_seed
      company.name = "New Updated Name"
      company.save
      expect(company.cwa_crypto_seed).to eq(old_seed)
    end
  end
end

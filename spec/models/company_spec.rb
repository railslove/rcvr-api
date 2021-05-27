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

  describe 'updates IRIS on create/update' do
    it 'should schedule a job for creates' do
      expect(IrisUpdateCompany).to receive(:perform_later)
      FactoryBot.create(:company)
    end

    it 'should schedule a job for updates' do
      company = FactoryBot.create(:company)
      expect(IrisUpdateCompany).to receive(:perform_later).with(company.id)
      company.update(name: "IRIS Update Name")
    end
  end

  describe 'informs IRIS about destroy' do
    it 'should schedule a job for updates' do
      company = FactoryBot.create(:company)
      expect(IrisDeleteCompany).to receive(:perform_later).with(company.id)
      company.destroy
    end
  end
end

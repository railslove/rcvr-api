class QrCodePdf
  include Interactor
  include RequiredAttributes

  required_attributes %i[area]

  delegate :company, to: :area

  def call
    context.file_name = "recover_qr_#{area.name}.pdf"
    context.data = pdf_data
  end

  private

  def pdf_data
    {
      pdt_id: 'area_qr_code.pdf',
      company_name: company.name,
      area_name: area.name,
      qr_code_link: qr_code_link
    }
  end

  def qr_code_link
    URI('https://rcvr.app/checkin/').tap do |uri|
      uri.query = {
        a: area.id,
        p: company.owner.public_key
      }.to_param
    end
  end
end

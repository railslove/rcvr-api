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
    URI.join('https://recoverapp.de/checkin/', company.id).tap do |uri|
      uri.query = { public_key: company.owner.public_key }.to_param
    end
  end
end

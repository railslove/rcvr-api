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
      pdt_id: 218,
      name: company.name,
      name: area.name,
      qrcode: qr_code_link
    }
  end

  def qr_code_link
    URI('https://rcvr.app/checkin/').tap do |uri|
      uri.query = {
        a: area.id,
        k: company.owner.public_key
      }.to_param
    end
  end
end

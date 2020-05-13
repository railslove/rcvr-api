class QrCodePdf
  include Interactor
  include RequiredAttributes

  required_attributes %i[area]

  delegate :company, to: :area
  delegate :owner, to: :company

  def call
    raise StandardError, "Owner #{owner.id} has no public_key" if owner.public_key.blank?

    context.file_name = "recover_qr_#{area.name}.pdf"
    context.data = pdf_data
  end

  private

  def pdf_data
    {
      pdt_id: 221,
      name: company.name,
      area: area.name,
      qrcode: qr_code_link
    }
  end

  def qr_code_link
    URI('https://rcvr.app/checkin').tap do |uri|
      uri.query = {
        a: area.id,
        k: company.owner.public_key
      }.to_param
    end
  end
end

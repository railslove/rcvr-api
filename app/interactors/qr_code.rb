class QrCode
  include Interactor
  include RequiredAttributes

  required_attributes %i[area]

  delegate :company, to: :area
  delegate :owner, to: :company

  def call
    raise StandardError, "Owner #{owner.id} has no public_key" if owner.public_key.blank?

    context.file_name = "recover_qr_#{area.name}.pdf"
    context.data = pdf_data
    context.svg = svg_data
  end

  private

  def svg_data
    qrcode = ::RQRCode::QRCode.new(qr_code_link.to_s)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
  end

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

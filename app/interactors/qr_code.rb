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
    context.png = png_data
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

  def png_data
    qrcode = ::RQRCode::QRCode.new(qr_code_link.to_s)
    qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 480
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

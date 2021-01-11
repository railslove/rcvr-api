class QrCode
  include Interactor
  include RequiredAttributes

  required_attributes %i[area format]

  delegate :company, to: :area
  delegate :owner, to: :company

  def call
    raise StandardError, "Owner #{owner.id} has no public_key" if owner.public_key.blank?

    context.file_name = "Recover QR - #{company.name} - #{area.name}.#{context.format}"

    handler_method = "#{context.format}_data"
    raise StandardError, "Unsopported Fromat: #{context.format}" unless respond_to?(handler_method, :include_private)

    context.data = send(handler_method)
  end

  private

  def svg_data
    qrcode = ::RQRCode::QRCode.new(area.checkin_link.to_s)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true
    )
  end

  def png_data
    qrcode = ::RQRCode::QRCode.new(area.checkin_link.to_s)
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
    ).to_s
  end

  def pdf_data
    {
      pdt_id: 221,
      name: company.name,
      area: area.name,
      qrcode: area.checkin_link
    }
  end

end

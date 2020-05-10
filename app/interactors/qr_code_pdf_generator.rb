class QrCodePdfGenerator
  include Interactor
  include RequiredAttributes

  required_attributes %i[company]

  def call
  end

  private

  def qr_code_link
    # TODO: Proper Frontend URL
    URL('https://recover.app/checkin/', company.id).tap do |url|
      url.query = { public_key: company.owner.public_key }.to_param
    end
  end
end

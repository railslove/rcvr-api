module DeviseOverwrites
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      build_resource(sign_up_params)

      affiliate = Affiliate.find_by(code: resource.affiliate)

      if affiliate and affiliate.custom_trial_phase
        # https://www.digi.com/resources/documentation/digidocs/90001437-13/reference/r_iso_8601_duration_format.htm
        resource.trial_ends_at = Time.now.advance(ActiveSupport::Duration.parse(affiliate.custom_trial_phase).parts)
      else
        resource.trial_ends_at = 14.days.from_now
      end

      resource.block_at = resource.trial_ends_at + 2.days
      resource.frontend = Frontend.find_by(frontend_params)

      resource.save!

      sign_in resource

      render json: resource
    end

    private

    def sign_up_params
      params.require(:owner).permit(:email, :password, :phone, :company_name, :name, :affiliate)
    end

    def frontend_params
      params.require(:frontend).permit(:url)
    end
  end
end

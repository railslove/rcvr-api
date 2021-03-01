module DeviseOverwrites
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      build_resource(sign_up_params)

      affiliate = Affiliate.find_by(code: resource.affiliate)
      # https://www.digi.com/resources/documentation/digidocs/90001437-13/reference/r_iso_8601_duration_format.htm
      if affiliate and affiliate.custom_trial_phase
        trial_phase = ActiveSupport::Duration.parse(affiliate.custom_trial_phase)
      else
        trial_phase = ActiveSupport::Duration.parse("P2W")
      end

      resource.trial_ends_at = trial_phase.since
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

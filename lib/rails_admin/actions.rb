module RailsAdmin
  module Config
    module Actions
      class BlockOwner < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          bindings[:object].class == Owner
        end

        register_instance_option(:member) { true }
        register_instance_option(:link_icon) { 'check' }
        register_instance_option(:pjax) { false}
        register_instance_option(:controller) do
          Proc.new do
            @object.update(block_at: Time.zone.now)
            @object.cancel_stripe_subscription!

            redirect_to back_or_index
          end
        end
      end

      class AcceptDataRequest < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          bindings[:object].class == DataRequest
        end

        register_instance_option(:member) { true }
        register_instance_option(:link_icon) { 'check' }
        register_instance_option(:pjax) { false}
        register_instance_option(:controller) do
          Proc.new do
            @object.accept!

            redirect_to back_or_index
          end
        end
      end
    end
  end
end

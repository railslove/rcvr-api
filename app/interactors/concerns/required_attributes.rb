module RequiredAttributes
  extend ActiveSupport::Concern

  included do
    def self.required_attributes(required_attributes)
      @required_attributes = required_attributes

      @required_attributes.each do |required_attribute|
        delegate required_attribute, to: :context
      end
    end

    before do
      @required_attributes&.each do |required_attribute|
        context.fail!(error: "#{required_attribute}_missing") if context[required_attribute].nil?
      end
    end
  end
end

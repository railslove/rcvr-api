class DurationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value == nil
      return
    end
    begin
      ActiveSupport::Duration.parse(value)
    rescue
      record.errors.add attribute, (options[:message] || "invalid duration")
    end
  end
end

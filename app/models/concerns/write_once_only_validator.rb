class WriteOnceOnlyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return if record.attribute_was(attribute).blank?
    return unless record.attribute_changed?(attribute)

    record.errors[attribute] << "#{attribute} can be written only once."
  end
end

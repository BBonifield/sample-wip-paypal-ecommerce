# test that a given model sets a specific default value on a given field
RSpec::Matchers.define :default_field do |field_name|
  chain :to_value do |value|
    @field_value = value
  end

  match do |model|
    # reset the field to ensure it's truly the default value
    reset_field_method = "reset_#{field_name}!".to_sym
    model.send(reset_field_method)

    model.send(field_name) == @field_value
  end

  failure_message_for_should do |model|
    "expected that #{field_name} would be defaulted to #{@field_value}"
  end

  failure_message_for_should_not do |model|
    "expected that #{field_name} would not be defaulted to #{@field_value}"
  end

  description do
    "default #{field_name} to #{@field_value}"
  end
end


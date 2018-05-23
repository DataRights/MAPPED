require 'active_support/concern'

module StringEnums
  extend ActiveSupport::Concern

  class_methods do
    def string_enum(enums_hash)
      enum_name = enums_hash.keys.first.to_s

      define_singleton_method(enum_name.pluralize) do
        result = {}
        enums_hash[enum_name.to_sym].each { |enum_key| result[enum_key] = I18n.t("enums.#{enum_name}.enum_key", :default => enum_key.to_s) }
        result
      end

      validation_method = "validate_#{enum_name}_values"
      validate validation_method.to_sym

      define_method(validation_method) do
        value = send(enum_name)
        errors.add(enum_name, I18n.t("validations.invalid_#{enum_name}", :default => "Invalid value for #{enum_name}, possible values are: #{self.class.send(enum_name.pluralize).values}")) unless value.blank? or self.class.send(enum_name.pluralize).keys.include?(value.to_sym)
      end
    end
  end

end

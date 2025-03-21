class ErrorField
  attr_reader :name, :errors

  def initialize(name, errors)
    @name = name
    @errors = errors
  end

  def as_json
    {
      'name' => name.to_s,
      'errors' => errors.as_json
    }
  end

  class << self
    # Creates an ErrorField instance from a field key and an ActiveModel error detail
    #
    # @param field [Symbol] the field with errors
    # @param errors_details [Array<Hash>] ActiveModel error detail
    # @return [ErrorField]
    def from_error_detail(field, errors_details)
      new(
        field,
        errors_details.map { |detail| detail[:error].is_a?(Symbol) ? detail[:error] : :invalid }
      )
    end
  end
end

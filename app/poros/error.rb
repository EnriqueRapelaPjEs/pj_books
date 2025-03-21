class Error
  attr_accessor :code, :description, :status_code, :message, :fields, :request_id

  def initialize(code, description, status_code, message, fields: [], request_id: nil, metadata: {}) # rubocop:disable Metrics/ParameterLists
    @code = code
    @description = description
    @status_code = status_code
    @message = message
    @fields = fields
    @request_id = request_id
    @metadata = metadata
  end

  def as_json
    json = {
      'code' => code,
      'description' => description,
      'message' => message,
      'request_id' => request_id
    }
    json['fields'] = fields.as_json if fields.present?
    json['metadata'] = @metadata.as_json if @metadata.present?

    json
  end

  class << self
    # Creates an Error instance for ActiveModel validations errors
    #
    # @param model [ActiveModel::Model]
    # @return [Error]
    def field_validation_error(model)
      new(
        1001,
        'FIELD_VALIDATION_ERROR',
        :unprocessable_entity,
        'One or more fields are invalid',
        fields: model.errors.details.map { |field, errors| ErrorField.from_error_detail(field, errors) }
      )
    end

    # Creates an Error instance for not found queries
    #
    # @param message [String]
    # @return [Error]
    def not_found(message)
      new(
        1002,
        'NOT_FOUND',
        :not_found,
        message
      )
    end

    def invalid_parameter(message, metadata = {})
      new(
        1007,
        'INVALID_PARAMETER',
        :bad_request,
        message,
        metadata: metadata
      )
    end

    def book_already_rented
      new(
        1008,
        'BOOK_ALREADY_RENTED',
        :bad_request,
        'Book is already rented'
      )
    end
  end
end

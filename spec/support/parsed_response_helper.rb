module Response
  module JSONParser
    def response_body
      ActiveSupport::JSON.decode(response.body) if response.present? && response.body.present?
    end

    def response_status
      response.status if response.present? && response.status.present?
    end
  end
end

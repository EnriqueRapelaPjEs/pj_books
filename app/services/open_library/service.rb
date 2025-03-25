module OpenLibrary
  class Service
    def fetch(isbn)
      response = HTTParty.get("https://openlibrary.org/api/books?bibkeys=ISBN:#{isbn}&jscmd=data&format=json")
      response.parsed_response
    end
  end
end

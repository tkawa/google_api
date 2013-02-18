module GoogleApi
  module Ga
    class ManagementFinder < Management
      def initialize(session)
        @session = session
      end

      def get(parameters = nil)
        JSON.parse(
          @session.client.execute(api_method: finder_api_method,
                                  parameters: parameters).body
        )["items"]
      end

      def get!(parameters = nil)
        JSON.parse(
          @session.client.execute!(api_method: finder_api_method,
                                   parameters: parameters).body
        )["items"]
      rescue Google::APIClient::TransmissionError => e
        raise GoogleApi::GaError, e.message
      end

      private
      def finder_api_method
        name = self.class.to_s.demodulize.sub(/Finder$/, '').underscore.pluralize
        @session.api.management.send(name).list
      end
    end
  end
end

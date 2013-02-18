module GoogleApi
  module Ga
    class DataFinder < Data
      def initialize(session)
        @session = session
        super()
      end

      def _session
        @session
      end
    end
  end
end

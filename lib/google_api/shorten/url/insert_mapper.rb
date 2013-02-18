module GoogleApi
  module Shorten
    class InsertMapper < Insert
      def initialize(session, long_url)
        @session = session
        super(long_url)
      end

      def _session
        @session
      end

    end
  end
end

module GoogleApi
  module Ga
    class ProfileFinder < ManagementFinder
      def all(account_id = '~all', webproperty_id = '~all')
        get(accountId: account_id, webPropertyId: webproperty_id)
      end

      def all!(account_id = '~all', webproperty_id = '~all')
        get!(accountId: account_id, webPropertyId: webproperty_id)
      end
    end
  end
end

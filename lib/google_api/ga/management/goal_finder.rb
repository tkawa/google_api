module GoogleApi
  module Ga
    class GoalFinder < ManagementFinder
      def all(account_id = '~all', webproperty_id = '~all', profile_id = '~all')
        get(accountId: account_id, webPropertyId: webproperty_id, profileId: profile_id)
      end

      def all!(account_id = '~all', webproperty_id = '~all', profile_id = '~all')
        get!(accountId: account_id, webPropertyId: webproperty_id, profileId: profile_id)
      end
    end
  end
end

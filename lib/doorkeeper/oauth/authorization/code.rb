module Doorkeeper
  module OAuth
    module Authorization
      class Code
        include URIBuilder

        DEFAULT_EXPIRATION_TIME = 600

        attr_accessor :authorization, :grant

        def initialize(authorization)
          @authorization = authorization
        end

        def issue_token
          @grant ||= AccessGrant.create!(
            :application_id    => authorization.client.id,
            :resource_owner_id => authorization.resource_owner.id,
            :expires_in        => DEFAULT_EXPIRATION_TIME,
            :project_id        => authorization.project_id,
            :redirect_uri      => authorization.redirect_uri,
            :scopes            => authorization.scopes.to_s
          )
        end

        def callback
          uri_with_query(authorization.redirect_uri, {
            :code  => grant.token,
            :state => authorization.state
          })
        end
      end
    end
  end
end

require 'middleman-core'
require 'contentful'

# The Contentful Middleman extensions allows to load managed content into Middleman projects through the Contentful Content Management Platform.
module ContentfulMiddleman
  class Core < ::Middleman::Extension
    self.supports_multiple_instances = false

    option :space, nil,
      'The Contentful Space ID and name'

    option :access_token, nil,
      'The Contentful Content Delivery API access token'

    option :cda_query, {},
      'The conditions that are used on the Content Delivery API to query for blog posts'

    option :mapper, nil,
      'Use a custom mapper to do the translation from the Contentful DynamicResources to Middleman'

    def initialize(app, options_hash={}, &block)
      super

      app.set :contentful_middleman, self
    end

    # The Contentful Gem client for the Content Delivery API
    def client
      @client ||= Contentful::Client.new(
        access_token:     options.access_token,
        space:            options.space.fetch(:id),
        dynamic_entries:  :auto
      )
    end

    #
    # Middleman hooks
    #
    def after_configuration
      massage_options

      app.set :contentful_middleman_client, client
    end

    #
    # Middleman helpers
    #
    helpers do
      # A helper method to access the Contentful Gem client
      def contentful
        contentful_middleman_client
      end
    end

    private
    def massage_options
      space_option          = options.space
      space_name            = space_option.keys.first
      space_id              = space_option.fetch(space_name)

      options.space = { name: space_name, id: space_id }
    end
  end
end

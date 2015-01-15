require 'middleman-core/cli'
require 'middleman-blog/uri_templates'
require 'date'
require_relative 'context'
require_relative 'delegated_yaml_writter'

module Middleman
  module Cli
    # This class provides an "contentful" command for the middleman CLI.
    class Contentful < Thor
      include Thor::Actions

      check_unknown_options!

      namespace :contentful
      desc 'contentful', 'Import data from Contentful'

      def self.source_root
        ENV['MM_ROOT']
      end

      # Tell Thor to exit with a nonzero exit code on failure
      def self.exit_on_failure?
        true
      end

      def initialize(*args, options, &block)
        super

        @content_type_mappers = {}
      end

      def contentful
        yaml_renderer = DelegatedYAMLWritter.new(self)
        client.entries(contentful_middleman_options.cda_query).each do |entry|
          context              = Context.new
          mapper               = content_type_mapper entry.content_type.id
          entry_data_file_path = data_file_path entry

          mapper.map context, entry
          yaml_renderer.render context, entry_data_file_path
        end

        shared_instance.logger.info 'Contentful Import: Done!'
      end

      private
        def shared_instance
          @shared_instance ||= ::Middleman::Application.server.inst
        end

        def content_type_mapper(content_type)
          @content_type_mappers[content_type] ||= begin
            content_type_options = contentful_middleman_options.content_types.fetch(content_type)
            mapper_class         = content_type_options.fetch(:mapper)
            mapper_class.new
          end
        end

        def contentful_middleman_options
          contentful_middleman.options
        end

        def contentful_middleman
          shared_instance.contentful_middleman
        end

        def client
          shared_instance.contentful_middleman_client
        end

        def data_file_path(entry)
          data_path(space_name,  content_type_name(entry.content_type.id), entry.id)
        end

        def data_path(space_name, content_type_name, entry_id)
          data_filename = "#{entry_id}.yaml"
          File.join(
            shared_instance.root_path.to_s,
            'data',
            space_name.to_s,
            content_type_name.to_s,
            data_filename)
        end

        def space_name
          @space_name ||= contentful_middleman_options.space.fetch(:name)
        end

        def content_type_name(content_type_id)
          contentful_middleman_options.content_types.fetch(content_type_id).fetch(:name)
        end
    end

  end
end

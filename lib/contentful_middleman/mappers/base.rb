require_relative '../commands/context'

module ContentfulMiddleman
  module Mapper
    class Base
      def map(context, entry, entries)
        context.id = entry.id
        entry.fields.each {|k, v| map_field context, k, v}
      end

      private

      def map_field(context, field_name, field_value)
        value_mapping = map_value(field_value)
        context.set(field_name, value_mapping)
      end

      def map_value(value)
        case value
        when Contentful::Asset
          map_asset(value)
        when Contentful::Location
          map_location(value)
        when Contentful::Link
          map_link(value)
        when Contentful::DynamicEntry
          map_entry(value)
        when Array
          map_array(value)
        else
          value
        end
      end

      def map_asset(asset)
        context       = Context.new
        context.title = asset.title
        context.url   = asset.file.url

        context
      end

      def map_entry(entry)
        context    = Context.new
        context.id = entry.id
        entry.fields.each {|k, v| map_field context, k, v}

        context
      end

      def map_location(location)
        location.properties
      end

      def map_link(link)
        context    = Context.new
        context.id = link.id

        context
      end

      def map_array(array)
        array.map {|element| map_value(element)}
      end
    end
  end
end

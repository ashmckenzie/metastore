require 'json'

module Metastore
  module Storage
    class JSON

      def initialize(file)
        @file = file
      end

      def contents
        file.exist? ? ::JSON.parse(file.read) : {}
      end

      def save!(values)
        File.open(file.to_s, 'w') { |f| f.write(values.to_json) }
      end

      private

        attr_reader :file
    end
  end
end

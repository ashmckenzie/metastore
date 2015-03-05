require 'yaml'

module Metastore
  module Storage
    class YAML

      def initialize(file)
        @file = file
      end

      def contents
        file.exist? ? ::YAML.load(file.read) : {}
      end

      def save!(values)
        File.open(file.to_s, 'w') { |f| f.write(values.to_yaml) }
      end

      private

        attr_reader :file
    end
  end
end

require 'yaml'

module Metastore
  module Storage
    class Base

      def initialize(file)
        @file = file
      end

      def contents
        file.exist? ? read : {}
      end

      def save!(values)
        File.open(file.to_s, 'w') { |f| f.write(to_write(values)) }
      end

      private

        attr_reader :file

        def read
          raise NotImplementedError
        end

        def to_write(values)
          raise NotImplementedError
        end

    end
  end
end

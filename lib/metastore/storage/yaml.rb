require 'yaml'

module Metastore
  module Storage
    class YAML < Base

      private

        def read
          ::YAML.load(file.read)
        end

        def to_write(values)
          values.to_yaml
        end
    end
  end
end

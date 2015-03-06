require 'json'

module Metastore
  module Storage
    class JSON < Base

      private

        def read
          ::JSON.parse(file.read)
        end

        def to_write(values)
          values.to_json
        end
    end
  end
end

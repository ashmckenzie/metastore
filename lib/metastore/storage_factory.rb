module Metastore
  class StorageFactory

    def self.from_sym(symbol)
      klass = symbol.to_s.upcase
      Storage.const_get(klass)
    rescue NameError => e
      raise Errors::UnknownStorageType, e.message
    end
  end
end

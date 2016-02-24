require 'fileutils'
require 'pathname'

module Metastore
  class Cabinet

    def initialize(file, separator: '.', storage_type: :yaml)
      @file = Pathname.new(file).expand_path
      @separator = separator
      @storage_type = storage_type
    end

    def get(key)
      split_key(key).inject(contents) do |c, k|
        c.is_a?(Hash) ? c[k] : nil
      end
    end

    def set(key, value)
      current_contents = contents
      set_key_and_value(current_contents, split_key(key), value)
      save!(current_contents)
    end

    def clear!
      save!({})
    end

    def contents
      storage.contents || {}
    end

    alias [] :get
    alias []= :set

    private

      attr_reader :file, :separator, :storage_type

      def storage
        @store || StorageFactory.from_sym(storage_type).new(file)
      end

      def split_key(key)
        key.to_s.split(separator)
      end

      def set_key_and_value(input, key, value)
        current_key = key.shift.to_s
        input[current_key] = {} unless input[current_key]

        if key.empty?
          input[current_key] = stringify_keys(value)
          input
        else
          input[current_key] = {} unless input[current_key].is_a?(Hash)
          set_key_and_value(input[current_key], key, value)
        end
      end

      def stringify_keys(input)
        case input
        when Hash
          Hash[
            input.map do |k, v|
              [ k.respond_to?(:to_s) ? k.to_s : k, stringify_keys(v) ]
            end
          ]
        when Enumerable
          input.map { |v| stringify_keys(v) }
        else
          input.is_a?(Symbol) ? input.to_s : input
        end
      end

      def save!(new_values)
        FileUtils.mkdir_p(file.dirname) unless file.exist?
        storage.save!(new_values)
        true
      rescue => e
        raise Errors::CabinetCannotSet, e.message
      end
  end
end

require 'fileutils'
require 'pathname'
require 'yaml'

module Metastore
  class Cabinet

    def initialize(file)
      @file = Pathname.new(file).expand_path
    end

    def get(key)
      split_key(key).inject(contents) { |c, k| c.is_a?(Hash) ? c[k] : nil }
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
      file.exist? ? YAML.load(file.read) || {} : {}
    end

    alias_method :[], :get
    alias_method :[]=, :set

    private

      attr_reader :file

      def split_key(key)
        key.to_s.split('.')
      end

      def set_key_and_value(input, key, value)
        current_key = key.shift.to_s
        input[current_key] = {} unless input[current_key]

        if key.empty?
          input[current_key] = recursive_stringify_keys(value)
          input
        else
          input[current_key] = {} unless input[current_key].is_a?(Hash)
          set_key_and_value(input[current_key], key, value)
        end
      end

      def recursive_stringify_keys(input)
        case input
        when Hash
          Hash[
            input.map do |k, v|
              [ k.respond_to?(:to_s) ? k.to_s : k, recursive_stringify_keys(v) ]
            end
          ]
        when Enumerable
          input.map { |v| recursive_stringify_keys(v) }
        else
          input.is_a?(Symbol) ? input.to_s : input
        end
      end

      def save!(new_values)
        FileUtils.mkdir_p(file.dirname) unless file.exist?
        File.open(file.to_s, 'w') { |f| f.write(new_values.to_yaml) }
      end

  end
end

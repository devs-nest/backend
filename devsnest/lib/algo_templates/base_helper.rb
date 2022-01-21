# frozen_string_literal: true

module Templates
  # Helper methods for algo template
  class BaseHelper
    def initialize(input_json, output_json , language_name)
      @head = ''
      @body = ''
      @tail = []
      @input_format = add_signatures(input_json.deep_symbolize_keys, language_name)
      @output_format = add_signatures(output_json.deep_symbolize_keys, language_name)
    end

    def add_signatures(var_data, language_name)
      language = Language.find_by(name: language_name)
      var_data.each do |_key, value|
        dtype = language["type_#{value[:variable][:datastructure]}"].to_s.gsub(/_/, value[:variable][:dtype])
        value.merge!(signature: "#{dtype} #{value[:name]}".strip)
      end
      var_data
    end

    def build_parameter_list
      @input_format.map do |_key, value|
        value[:signature]
      end
    end


    def get_output_signature
      @output_format.map do |_key, value|
        value[:signature]
      end
    end

    def get_input_signature
      @input_format.map do |_key, value|
        value[:signature]
      end
    end

    def get_return_type
      @output_format.map do |_key, value|
        value[:signature].split(' ')&.first
      end
    end

    def build_argument_list
      @input_format.map do |_key, value|
        value[:name]
      end
    end

    def build
      {
        head: @head,
        body: @body,
        tail: @tail
      }
    end
  end
end

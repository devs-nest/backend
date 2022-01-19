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

  class Python2 < BaseHelper
    def initialize(input_json, output_json)
      super(input_json, output_json, 'python2')

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      ''
    end

    def build_body
      ["def solve(#{build_argument_list.join(', ')}):", "\t# CODE HERE"].join("\n")
    end

    def build_tail
      # build inputs
      tail_code = []
      tail_code << "if __name__ == '__main__':"
      tail_code += input_code
      # build call
      tail_code << "#{get_output_signature.join(', ')} = solve(#{build_parameter_list.join(', ')})"
      # build prints
      tail_code += output_code
      tail_code.join("\n\t")
    end

    def input_code
      inputs = []
      @input_format.each do |_key, value|
        inputs += case value[:variable][:datastructure]
                  when 'string'
                    ["#{value[:name]} = raw_input()"]
                  when 'array', 'list', 'tuple'
                    ["#{value[:name]} = list(map(#{value[:variable][:dtype]}, raw_input().split()))"]
                  when 'primitive'
                    ["#{value[:name]} = #{value[:variable][:dtype]}(raw_input())"]
                  when 'matrix'
                    ['n,m = list(map(int, raw_input().split()))', "#{value[:name]}=[ [#{value[:variable][:dtype]}(j) for j in raw_input().split()] for i in xrange(n)]"]
                  end
      end
      inputs
    end

    def output_code
      outputs = []
      @output_format.each do |_key, value|
        outputs += case value[:variable][:datastructure]
                   when 'string', 'primitive'
                     ["print(#{value[:name]})"]
                   when 'list', 'tuple', 'array'
                     ["for i in #{value[:name]}:", "\tprint(i, end = ' ')"]
                   when 'matrix',
                     ["for i in #{value[:name]}:", "\tfor j in i:", "\t\tprint(j, end = ' ')", "\tprint()"]
                   end
      end
      outputs
    end
  end
  # python3 algo template
  class Python3 < BaseHelper
    def initialize(input_json, output_json)
      super(input_json, output_json, 'python3')

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      ''
    end

    def build_body
      ["def solve(#{build_argument_list.join(', ')}):", "\t# CODE HERE"].join("\n")
    end

    def build_tail
      # build inputs
      tail_code = []
      tail_code << "if __name__ == '__main__':"
      tail_code += input_code
      # build call
      tail_code << "#{get_output_signature.join(', ')} = solve(#{build_parameter_list.join(', ')})"
      # build prints
      tail_code += output_code
      tail_code.join("\n\t")
    end

    def input_code
      inputs = []
      @input_format.each do |_key, value|
        inputs += case value[:variable][:datastructure]
                  when 'string'
                    ["#{value[:name]} = input()"]
                  when 'array', 'list', 'tuple'
                    ["#{value[:name]} = list(map(#{value[:variable][:dtype]}, input().split()))"]
                  when 'primitive'
                    ["#{value[:name]} = #{value[:variable][:dtype]}(input())"]
                  when 'matrix'
                    ['n,m = list(map(int, input().split()))', "#{value[:name]}=[ [#{value[:variable][:dtype]}(j) for j in input().split()] for i in range(n)]"]
                  end
      end
      inputs
    end

    def output_code
      outputs = []
      @output_format.each do |_key, value|
        outputs += case value[:variable][:datastructure]
                   when 'string', 'primitive'
                     ["print(#{value[:name]})"]
                   when 'list', 'tuple', 'array'
                     ["for i in #{value[:name]}:", "\tprint(i, end = ' ')"]
                   when 'matrix',
                     ["for i in #{value[:name]}:", "\tfor j in i:", "\t\tprint(j, end = ' ')", "\tprint()"]
                   end
      end
      outputs
    end
  end

  class CPP < BaseHelper
    def initialize(input_json, output_json)
      super(input_json, output_json, 'cpp')

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      ['#include<bits/stdc++.h>', 'using namespace std;'].join("\n")
    end

    def build_body
      "#{get_return_type.join(", ")} solve(#{build_parameter_list.join(', ')}){\n//CODE HERE \n}"
    end

    def build_tail
      tail_code = []

      tail_code << "int main(){"
      tail_code += get_input_signature.map { |signature| signature + ";"}
      tail_code += input_code
      tail_code << "#{get_output_signature.join(', ')} = solve(#{build_argument_list.join(', ')});"
      tail_code += output_code
      tail_code += ["return 0;", "}"]
      tail_code.join("\n")
    end

    def input_code
      inputs = []
      @input_format.each do |_key, value|
        inputs += case value[:variable][:datastructure]
        when 'primitive' 
          ["cin >> #{value[:name]};"]
        when 'string'
          ["getline(cin,#{value[:name]});"]
        when 'array'
          ["for (int i = 0; i < #{value[:variable][:dependent]&.first}; i++){", "#{value[:variable][:dtype]} temp;", "cin >> temp;", "#{value[:name]}.push_back(temp);", "}"]
        when 'matrix'
          ["#{value[:name]}.resize(#{value[:variable][:dependent]&.first});","for (int r = 0; r < #{value[:variable][:dependent]&.first}; r++){", "for (int c = 0; c < #{value[:variable][:dependent]&.second}; c++){", "#{value[:variable][:dtype]} temp;", "cin >> temp;", "#{value[:name]}[r].push_back(temp);","}","}"]
        end
      end
    inputs
    end

    def output_code
      outputs = []
      @output_format.each do |_key, value|
        outputs += case value[:variable][:datastructure]
                   when 'string', 'primitive'
                     ["cout << #{value[:name]};"]
                   when 'array'
                     ["for (#{value[:variable][:dtype]} i: #{value[:name]}){", "cout << i << ' ';", "}"]
                   when 'matrix'
                     ["for (int r = 0; r < #{value[:name]}.size(); r++){", "for (int c = 0; c < #{value[:name]}[r].size(); c++){", "cout << #{value[:name]}[r][c];", "}", "}"]
                   end
      end
      outputs
    end
  end

  class Java < BaseHelper
    def initialize(input_json, output_json)
      super(input_json, output_json, 'java')
      
      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      [
        "import java.io.*;",
        "import java.math.*;",
        "import java.security.*;",
        "import java.text.*;",
        "import java.util.*;",
        "import java.util.concurrent.*;",
        "import java.util.function.*;",
        "import java.util.regex.*;",
        "import java.util.stream.*;",
        "import static java.util.stream.Collectors.joining;",
        "import static java.util.stream.Collectors.toList;",
        "public class Main {"
    ].join("\n")
    end

    def build_body
      "#{get_return_type.join(", ")} solve(#{build_parameter_list.join(', ')}){\n//CODE HERE \n}"
    end

    def build_tail
      tail_code = []

      tail_code << "public static void main(String[] args) throws Exception{"
      tail_code << "BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));"
      tail_code += get_input_signature.map { |signature| signature + ";"}
      tail_code += get_output_signature.map { |signature| signature + ";"}

      tail_code += ["}", "}"]

      tail_code.join("\n")
    end

    def input_code
      inputs = []
      @input_format.each do |_key, value|
        inputs += case value[:variable][:datastructure]
        when 'string'
          ["#{value[:name]} = bufferedReader.readLine().trim();"]
        when 'array', 'list', 'tuple'
          ["#{value[:name]} = new #{value[:variable][:dtype]}[#{value[:variable][:dependent]&.first}]"]
        when 'primitive'
          ["#{value[:name]} = #{
            case value[:variable][:dtype]
            when 'int'
              ["Integer.parseInt(bufferedReader.readLine().trim());"]
            when 'long'
              ["Long.parseLong(bufferedReader.readLine().trim());"]
            when 'char'
              ["(char)bufferedreader.read().trim();"]
            end
          }"]
        when 'matrix'
          ["#{value[:name]} = new #{value[:variable][:dtype]}[#{value[:variable][:dependent]&.first}][#{value[:variable][:dependent]&.second}]"]
        end
        
      end
    end

    def output_code
    end
  end

  class JavaScript < BaseHelper
    def initialize(input_json, output_json)
      super(input_json, output_json, 'javascript')
      
      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "template_files/parserat.js").body.read
    end

    def input_code
      [
        "const readline = require('readline');",
        "const { stdin: input, stdout: output } = require('process');",
        "const rl = readline.createInterface({ input, output });",
        "let raw_inputs = [];",
        "rl.on('line', (input) => {",
        "raw_inputs.push(input);",
        "if (raw_inputs.length === #{@input_format.length}){",
        "rl.close();",
        "parsed_inputs = parse(raw_inputs, #{@input_format.to_json.dump});",
        "#{get_output_signature.join(', ')} = main(...parsed_inputs);",
        "}"
      ]
    end

    def output_code
      outputs = []
      @output_format.each do |_key, value|
        outputs += case value[:variable][:datastructure]
        when 'string', 'primitive'
          ["console.log(#{value[:name]})"]
        when 'list', 'tuple', 'array'
          ["console.log(...#{value[:name]})"]
        when 'matrix',
          ["#{value[:name]}.forEach(", "(element) => console.log(...element)", ");"]
        end
      end
      outputs
    end

    def build_body
      ["function solve(#{build_parameter_list.join(', ')}){", "// CODE HERE","}"].join("\n")
    end

    def build_tail
      tail_code = []
      tail_code += input_code
      tail_code << build_body
      tail_code += ["let #{get_output_signature.join(', ')};", "function main(inputs){", "#{get_output_signature.join(', ')} = inputs", "}"]
      tail_code += output_code

      tail_code.join("\n")
    end
  end
end

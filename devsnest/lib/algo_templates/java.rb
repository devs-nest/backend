require 'algo_templates/base_helper'
class Templates::Java < Templates::BaseHelper
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
    @input_format.each do | value|
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
require 'algo_templates/base_helper'
class Templates::Java < Templates::BaseHelper
  def initialize(input_json, output_json)
    super(input_json, output_json, 'java')
    
    @head = build_head
    @body = build_body
    @tail = build_tail
  end

  def create_class(type, conn)
    case type
    when "int"
      "Integer#{conn}parseInt"
    when "float"
      "Float#{conn}parseFloat"
    when "long"
      "Long#{conn}parseLong"
    end
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
    tail_code += input_code
    tail_code << "#{get_output_signature.join(', ')} = solve(#{build_argument_list.join(', ')});"
    tail_code += output_code

    tail_code += ["}", "}"]

    tail_code.join("\n")
  end

  def input_code
    inputs = []
    @input_format.each do |value|
      inputs += case value[:variable][:datastructure]
      when 'string'
        ["#{value[:name]} = bufferedReader.readLine().trim();"]
      when 'array', 'list', 'tuple'
        ["#{value[:name]} = new #{value[:variable][:dtype]}[#{value[:variable][:dependent]&.first}]", "#{value[:name]} = Arrays.stream(bufferedReader.readLine().trim().split(" ")).mapToInt(#{create_class(value[:variable][:dtype], '::')}).toArray();"]
      when 'primitive'
        ["#{value[:name]} = #{create_class(value[:variable][:dtype], '.')}(bufferedReader.readLine().trim());"]
      when 'matrix'
        ["#{value[:name]} = new #{value[:variable][:dtype]}[#{value[:variable][:dependent]&.first}][#{value[:variable][:dependent]&.second}]", "for(int i=0;i<#{value[:variable][:dependent]&.first};i++){", "#{value[:name]}[i] = Arrays.stream(bufferedReader.readLine().trim().split(" ")).mapToInt(#{create_class(value[:variable][:dtype], '::')}).toArray();", "}"]
      end
    end
    inputs
  end

  def output_code
    outputs = []
    @output_format.each do |value|
      outputs += case value[:variable][:datastructure]
      when 'primitive', 'string'
        ["System.out.println(#{value[:name]})"]
      when 'array'
        ["System.out.println(Arrays.toString(#{value[:name]}).replaceAll('\\\\[|\\\\]|,', ''));"]
      when 'matrix'
        ["for (int i = 0; i < #{value[:name]}.length; i++){", "System.out.println(Arrays.toString(#{value[:name]}[i]).replaceAll('\\\\[|\\\\]|,', ''));", "}"]
      end
    end
    outputs
  end
end

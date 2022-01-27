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

  def input_builder(name, datastructure, dtype, dependent)
    meta = { 
      "primitive" => {
        "int" => ["#{name} = #{create_class('int', '.')}(bufferedReader.readLine().trim());"],
        "float" => ["#{name} = #{create_class('float', '.')}(bufferedReader.readLine().trim());"],
        "string" => ["#{name} = bufferedReader.readLine().trim();"]
      },
      "array" => {
        "int" => ["#{name} = new int[#{dependent&.first}]", "#{name} = Arrays.stream(bufferedReader.readLine().trim().split(" ")).mapToInt(#{create_class('int', '::')}).toArray();"],
        "float" => ["#{name} = new float[#{dependent&.first}]", "#{name} = Arrays.stream(bufferedReader.readLine().trim().split(" ")).mapToFloat(#{create_class('float', '::')}).toArray();"],
        "string" => ["#{name} = new String[#{dependent&.first}]", "#{name} = Arrays.stream(bufferedReader.readLine().trim().split(" ")).toArray();"]
      },
      "matrix" => {
        "int" =>  ["#{name} = new int[#{dependent&.first}][#{dependent&.second}]", "for(int i=0;i<#{dependent&.first};i++){", "#{name}[i] = Arrays.stream(bufferedReader.readLine().trim().split(" ")).mapToInt(#{create_class('int', '::')}).toArray();", "}"],
        "float" => ["#{name} = new float[#{dependent&.first}][#{dependent&.second}]", "for(int i=0;i<#{dependent&.first};i++){", "#{name}[i] = Arrays.stream(bufferedReader.readLine().trim().split(" ")).mapToFloat(#{create_class('float', '::')}).toArray();", "}"],
        "string" => ["#{name} = new String[#{dependent&.first}][#{dependent&.second}]", "for(int i=0;i<#{dependent&.first};i++){", "#{name}[i] = Arrays.stream(bufferedReader.readLine().trim().split(" ")).toArray();", "}"]
      }
    }
    meta[datastructure][dtype]
  end

  def output_builder(name, datastructure, dtype)
    meta = { 
      "primitive" => {
        "int" => ["System.out.println(#{name})"],
        "float" => ["System.out.println(#{name})"],
        "string" => ["System.out.println(#{name})"]
      },
      "array" => {
        "int" => ["System.out.println(Arrays.toString(#{name}).replaceAll('\\\\[|\\\\]|,', ''));"],
        "float" => ["System.out.println(Arrays.toString(#{name}).replaceAll('\\\\[|\\\\]|,', ''));"],
        "string" => ["System.out.println(Arrays.toString(#{name}).replaceAll('\\\\[|\\\\]|,', ''));"]
      },
      "matrix" => {
        "int" => ["for (int i = 0; i < #{name}.length; i++){", "System.out.println(Arrays.toString(#{name}[i]).replaceAll('\\\\[|\\\\]|,', ''));", "}"],
        "float" => ["for (int i = 0; i < #{name}.length; i++){", "System.out.println(Arrays.toString(#{name}[i]).replaceAll('\\\\[|\\\\]|,', ''));", "}"],
        "string" => ["for (int i = 0; i < #{name}.length; i++){", "System.out.println(Arrays.toString(#{name}[i]).replaceAll('\\\\[|\\\\]|,', ''));", "}"]
      }
    }
    meta[datastructure][dtype]
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
      inputs += input_builder(value[:name], value[:variable][:datastructure], value[:variable][:dtype], value[:variable][:dependent])
    end
    inputs
  end

  def output_code
    outputs = []
    @output_format.each do |value|
      outputs += output_builder(value[:name], value[:variable][:datastructure], value[:variable][:dtype])
    end
    outputs
  end
end

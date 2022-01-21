require 'algo_templates/base_helper'
class Templates::CPP < Templates::BaseHelper
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


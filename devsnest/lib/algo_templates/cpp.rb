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
    "#{get_return_type.join(', ')} solve(#{build_parameter_list.join(', ')}){\n//CODE HERE \n}"
  end

  def build_tail
    tail_code = []

    tail_code << 'int main(){'
    tail_code += get_input_signature.map { |signature| signature + ';' }
    tail_code += input_code
    tail_code << "#{get_output_signature.join(', ')} = solve(#{build_argument_list.join(', ')});"
    tail_code += output_code
    tail_code += ['return 0;', '}']
    tail_code.join("\n")
  end

  def input_builder(name, datastructure, dtype, dependent)
    meta = {
      'primitive' => {
        'int' => ["cin >> #{name};"],
        'float' => ["cin >> #{name};"],
        'string' => ["getline(cin,#{name});"]
      },
      'array' => {
        'int' => ["for (int i = 0; i < #{dependent&.first}; i++){", 'int temp;', 'cin >> temp;', "#{name}.push_back(temp);", '}'],
        'float' => ["for (int i = 0; i < #{dependent&.first}; i++){", 'float temp;', 'cin >> temp;', "#{name}.push_back(temp);", '}'],
        'string' => ["for (int i = 0; i < #{dependent&.first}; i++){", 'string temp;', 'cin >> temp;', "#{name}.push_back(temp);", '}']
      },
      'matrix' => {
        'int' => ["#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'int temp;', 'cin >> temp;',
                  "#{name}[r].push_back(temp);", '}', '}'],
        'float' => ["#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'float temp;', 'cin >> temp;',
                    "#{name}[r].push_back(temp);", '}', '}'],
        'string' => ["#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'string temp;',
                     'getline(cin, temp);', "#{name}[r].push_back(temp);", '}', '}']
      }
    }
    meta[datastructure][dtype]
  end

  def output_builder(name, datastructure, dtype)
    meta = {
      'primitive' => {
        'int' => ["cout << #{name};"],
        'float' => ["cout << #{name};"],
        'string' => ["cout << #{name};"]
      },
      'array' => {
        'int' => ["for (#{dtype} i: #{name}){", "cout << i << ' ';", '}'],
        'float' => ["for (#{dtype} i: #{name}){", "cout << i << ' ';", '}'],
        'string' => ["for (#{dtype} i: #{name}){", "cout << i << ' ';", '}']
      },
      'matrix' => {
        'int' => ["for (int r = 0; r < #{name}.size(); r++){", "for (int c = 0; c < #{name}[r].size(); c++){", "cout << #{name}[r][c];", '}', '}'],
        'float' => ["for (int r = 0; r < #{name}.size(); r++){", "for (int c = 0; c < #{name}[r].size(); c++){", "cout << #{name}[r][c];", '}', '}'],
        'string' => ["for (int r = 0; r < #{name}.size(); r++){", "for (int c = 0; c < #{name}[r].size(); c++){", "cout << #{name}[r][c];", '}', '}']
      }
    }
    meta[datastructure][dtype]
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

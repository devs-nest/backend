# python3 algo template
require 'algo_templates/base_helper'
class Templates::Python3 < Templates::BaseHelper
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

  def input_builder(name, datastructure, dtype, dependent)
    meta = {
      'primitive' => {
        'int' => ['int(input())'],
        'float' => ['float(input())'],
        'string' => ['input()']
      },
      'array' => {
        'int' => ['list(map(int, input().split()))'],
        'float' => ['list(map(float, input().split()))'],
        'string' => ['input().split()']
      },
      'matrix' => {
        'int' => ["[ [int(j) for j in input().split()] for i in range(#{dependent&.first})]"],
        'float' => ["[ [float(j) for j in input().split()] for i in range(#{dependent&.first})]"],
        'string' => ["[ [j for j in input().split()] for i in range(#{dependent&.first})]"]
      }
    }
    ["#{name} = #{meta[datastructure][dtype].join('\n')}"]
  end

  def output_builder(name, datastructure, dtype)
    meta = {
      'primitive' => {
        'int' => ["print(#{name})"],
        'float' => ["print(#{name})"],
        'string' => ["print(#{name})"]
      },
      'array' => {
        'int' => ["print(*#{name})"],
        'float' => ["print(*#{name})"],
        'string' => ["print(*#{name})"]
      },
      'matrix' => {
        'int' => ["for i in #{name}:", "\tprint(*i)"],
        'float' => ["for i in #{name}:", "\tprint(*i)"],
        'string' => ["for i in #{name}:", "\tprint(*i)"]
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

# python3 algo template
require 'algo_templates/base_helper'
class Templates::Python3 < Templates::BaseHelper
  def initialize(input_json, output_json, topic)
    super(input_json, output_json, 'python3')
    @topic = topic

    @head = build_head
    @body = build_body
    @tail = build_tail
  end

  def build_head
    head_code = []
    if @topic == 'linkedlist'
      head_code += linked_list_node_class
      head_code += linked_list_convert_function
      head_code += linked_list_print_function
    end
    head_code.join("\n")
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

  def linked_list_node_class
    ['class Node:', "\tdef __init__(self, data):", "\t\tself.data = data", "\t\tself.next = None"]
  end

  def linked_list_convert_function
    ['def convertToLL(arr, n):', "\thead = None", "\ttail = None", "\tfor i in arr:", "\t\tnode = Node(i)", "\t\tif not head:", "\t\t\thead = node", "\t\tif tail:", "\t\t\ttail.next = node", "\t\ttail = node", "\treturn head"]
  end

  def linked_list_print_function
    ['def printLL(head):', "\twhile head:", "\t\tprint(head.data, end = ' ')", "\t\thead = head.next", "\tprint()"]
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
      },
      'linked_list' => {
        'int' => ["raw_array = list(map(int, input().split()))", "#{name} = convertToLL(raw_array, len(raw_array))"]
      }
    }
    
    if datastructure == 'linked_list'
      ["#{meta[datastructure][dtype].join('\n')}"]
    else
      ["#{name} = #{meta[datastructure][dtype].join('\n')}"]
    end
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
      },
      'linked_list' => {
        'int' => ["printLL(#{name})"]
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

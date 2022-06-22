# frozen_string_literal: true

# python3 algo template
require 'algo_templates/base_helper'
module Templates
  class Python3 < Templates::BaseHelper
    def initialize(input_json, output_json, topic)
      super(input_json, output_json, 'python3')
      @topic = topic

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      head_code = ['from collections import deque']
      case @topic
      when 'linkedlist'
        head_code += linked_list_node_class
        head_code += linked_list_convert_function
        head_code += linked_list_print_function
      when 'tree'
        head_code += tree_node_class
        head_code += tree_create_level
        head_code += tree_convert_function
        head_code += trim_nones_tree_parse
        head_code += parse_tree_function
      end
      head_code.join("\n")
    end

    def build_body
      ["def solve(#{build_argument_list.join(', ')}):", "    # CODE HERE"].join("\n")
    end

    def build_tail
      # build inputs
      tail_code = []
      tail_code << "\nif __name__ == '__main__':"
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
      ['def convertToLL(arr, n):', "\thead = None", "\ttail = None", "\tfor i in arr:", "\t\tnode = Node(int(i))", "\t\tif not head:", "\t\t\thead = node", "\t\tif tail:", "\t\t\ttail.next = node",
       "\t\ttail = node", "\treturn head"]
    end

    def linked_list_print_function
      ['def printLL(head):', "\twhile head:", "\t\tprint(head.data, end = ' ')", "\t\thead = head.next", "\tprint()"]
    end

    def tree_node_class
      ['class TreeNode:', "\tdef __init__(self, val):", "\t\tself.left = None", "\t\tself.right = None", "\t\tself.val = val"]
    end

    def tree_convert_function
      ['def create_tree(raw_array):', "\troot = TreeNode(raw_array[0])", "\tparent_level = [root]", "\tchild_level = []", "\tnodes_to_be_in_current_level = 2",
       "\tnodes_to_be_in_next_level = 2 * nodes_to_be_in_current_level", "\tfor i in raw_array[1:]:", "\t\tif not i:", "\t\t\tnodes_to_be_in_next_level -= 2", "\t\t\tnode = None", "\t\telse:", "\t\t\tnode = TreeNode(i)", "\t\tchild_level.append(node)", "\t\tnodes_to_be_in_current_level -= 1", "\t\tif nodes_to_be_in_current_level == 0:", "\t\t\tcreate_tree_level(parent_level, child_level)", "\t\t\tnodes_to_be_in_current_level = nodes_to_be_in_next_level", "\t\t\tnodes_to_be_in_next_level *= 2", "\t\t\tparent_level = child_level", "\t\t\tchild_level = []", "\tif child_level:", "\t\tcreate_tree_level(parent_level, child_level)", "\treturn root"]
    end

    def tree_create_level
      ['def create_tree_level(parent, child):', "\tchild_iter = iter(child)", "\tfor p in parent:", "\t\tif not p:", "\t\t\tcontinue", "\t\tp.left = next(child_iter, None)",
       "\t\tp.right = next(child_iter, None)"]
    end

    def trim_nones_tree_parse
      ['def trim_nones(arr):', "\ti = len(arr) - 1", "\twhile arr[i] == 'null':", "\t\tarr.pop()", "\t\ti -= 1"]
    end

    def parse_tree_function
      ['def parse_tree(root):', "\tqueue = deque([root])", "\ttree_array = [root.val]", "\twhile queue:", "\t\tcurr = queue.popleft()", "\t\tif curr.left:", "\t\t\tqueue.append(curr.left)",
       "\t\t\ttree_array.append(curr.left.val)", "\t\telse:", "\t\t\ttree_array.append(\"null\")", "\t\tif curr.right:", "\t\t\tqueue.append(curr.right)", "\t\t\ttree_array.append(curr.right.val)", "\t\telse:", "\t\t\ttree_array.append(\"null\")", "\ttrim_nones(tree_array)", "\treturn tree_array"]
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
          'int' => ['mat_dims = list(map(int, input().split()))', "\t#{name} = [ [int(j) for j in input().split()] for i in range(#{dependent&.first})]"],
          'float' => ['mat_dims = list(map(int, input().split()))', "\t#{name} = [ [float(j) for j in input().split()] for i in range(#{dependent&.first})]"],
          'string' => ['mat_dims = list(map(int, input().split()))', "\t#{name} = [ [j for j in input().split()] for i in range(#{dependent&.first})]"]
        },
        'linked_list' => {
          'int' => ['raw_array = list(map(int, input().split()))', "\t#{name} = convertToLL(raw_array, len(raw_array))"]
        },
        'binary_tree' => {
          'int' => ['convert_block = lambda x: int(x) if x != "null" else None', "\traw_array = list(map(convert_block, input().split(' ')))", "\t#{name} = create_tree(raw_array)"]
        }
      }

      if %w[linked_list matrix].include?(datastructure)
        [meta[datastructure][dtype].join("\n").to_s]
      else
        ["#{name} = #{meta[datastructure][dtype].join("\n")}"]
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
        },
        'binary_tree' => {
          'int' => ["print(*parse_tree(#{name}))"]
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
end

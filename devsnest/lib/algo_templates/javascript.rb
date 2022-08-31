# frozen_string_literal: true

require 'algo_templates/base_helper'
module Templates
  class JavaScript < Templates::BaseHelper
    def initialize(input_json, output_json, topic)
      super(input_json, output_json, 'javascript')
      @topic = topic

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      head_code = [$s3.get_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: 'template_files/parserat.js').body.read]
      case @topic
      when 'linkedlist'
        head_code += linked_list_node_class
        head_code += linked_list_print_function
      when 'tree'
        tree_functions = [tree_node_class, tree_input_convert_block, tree_level_iterator, tree_level_function, tree_create_function, tree_trim_nones_function, tree_parse_function].flatten
        head_code += tree_functions
      end
      head_code.join("\n")
    end

    def input_code
      [
        "parsed_inputs = ParseInput(input, #{@input_format.to_json.dump});",
        'main(parsed_inputs);'
      ]
    end

    def output_code
      outputs = []
      @output_format.each do |value|
        outputs += case value[:variable][:datastructure]
                   when 'string', 'primitive'
                     ["console.log(#{value[:name]})"]
                   when 'list', 'tuple', 'array'
                     ["console.log(...#{value[:name]})"]
                   when 'matrix'
                     ["#{value[:name]}.forEach(", '(element) => console.log(...element)', ');']
                   when 'linked_list'
                     ["printLL(#{value[:name]})"]
                   when 'binary_tree'
                     ["console.log(...parse_tree(#{value[:name]}))"]
                   end
      end
      outputs
    end

    def build_body
      ["function solve(#{build_parameter_list.join(', ')}){", '// CODE HERE', '}'].join("\n")
    end

    def build_tail
      tail_code = []
      tail_code += input_code
      tail_code += ['function main(inputs){', "let {#{build_parameter_list.join(', ')}} = inputs", "let #{get_output_signature.join(', ')} = solve(#{build_parameter_list.join(', ')})"]
      tail_code += output_code
      tail_code += ['}']

      tail_code.join("\n")
    end

    def linked_list_node_class
      ['class Node {', 'constructor(data) {', "\tthis.data = data", "\tthis.next = null", '}', '}']
    end

    def linked_list_print_function
      ['function printLL(head){', 'let s = "";', "\twhile (head){", "\t\ts += head.data + \" \";", "\t\thead = head.next", "\t}", 'console.log(s.trim())', '}']
    end

    def tree_node_class
      ['class TreeNode{', "\tconstructor(val) {", "\t\tthis.val = val", "\t\tthis.left = null", "\t\tthis.right = null", "\t}", '}']
    end

    def tree_input_convert_block
      ['function convert_block(num) {', "\tif (num === \"null\"){", "\t\treturn null", "\t}", "\telse{", "\t\treturn parseInt(num)", "\t}", '}']
    end

    def tree_level_iterator
      ['function* iter(array) {', "\tfor (let i = 0; i < Number.MAX_VALUE; i+=1){", "\t\tif (i >= array.length){", "\t\t\tyield null", "\t\t}", "\t\telse{", "\t\t\tyield array[i]", "\t\t}", "\t}",
       '}']
    end

    def tree_level_function
      ['function create_tree_level(parent, child){', "\tlet child_iter = iter(child)", "\tfor (let p of parent){", "\t\tif (!p){", "\t\t\tcontinue", "\t\t}", "\t\tp.left = child_iter.next().value",
       "\t\tp.right = child_iter.next().value", "\t}", '}']
    end

    def tree_create_function
      ['function create_tree(raw_array){', "\tlet root = new TreeNode(raw_array[0])", "\tlet parent_level = [root]", "\tlet child_level = []", "\tlet nodes_to_be_in_current_level = 2",
       "\tlet nodes_to_be_in_next_level = 2 * nodes_to_be_in_current_level", "\tfor (let i = 1; i < raw_array.length; i+=1){", "\t\tif (!raw_array[i]){", "\t\t\tnodes_to_be_in_next_level -= 2", "\t\t\tnode = null", "\t\t}", "\t\telse{", "\t\t\tnode = new TreeNode(raw_array[i])", "\t\t}", "\t\tchild_level.push(node)", "\t\tnodes_to_be_in_current_level -= 1", "\t\tif (nodes_to_be_in_current_level === 0){", "\t\t\tcreate_tree_level(parent_level, child_level)", "\t\t\tnodes_to_be_in_current_level = nodes_to_be_in_next_level", "\t\t\tnodes_to_be_in_next_level *= 2", "\t\t\tparent_level = child_level", "\t\t\tchild_level = []", "\t\t}", "\t}", "\tif (child_level.length){", "\t\tcreate_tree_level(parent_level, child_level)", "\t}", "\treturn root", '}']
    end

    def tree_trim_nones_function
      ['function trim_nones(arr){', "\tlet i = arr.length - 1", "\twhile (arr[i] === 'null'){", "\t\tarr.pop()", "\ti -= 1", "\t}", '}']
    end

    def tree_parse_function
      ['function parse_tree(root){', "\tqueue = [root]", "\ttree_array = [root.val]", "\twhile (queue.length){", "\t\tlet curr = queue.shift()", "\t\tif (curr.left){", "\t\t\tqueue.push(curr.left)",
       "\t\t\ttree_array.push(curr.left.val)", "\t\t}", "\t\telse{", "\t\t\ttree_array.push('null')", "\t\t}", "\t\tif (curr.right){", "\t\t\tqueue.push(curr.right)", "\t\t\ttree_array.push(curr.right.val)", "\t\t}", "\t\telse{", "\t\t\ttree_array.push('null')", "\t\t}", "\t}", "\ttrim_nones(tree_array)", "\treturn tree_array", '}']
    end
  end
end

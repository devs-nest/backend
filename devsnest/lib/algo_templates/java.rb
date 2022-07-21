# frozen_string_literal: true

require 'algo_templates/base_helper'
module Templates
  class Java < Templates::BaseHelper
    def initialize(input_json, output_json, topic)
      super(input_json, output_json, 'java')
      @topic = topic

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def add_signatures(var_data, language_name)
      language = Language.find_by(name: language_name)
      var_data.each do |value|
        sig_type = if value[:variable][:dtype] == 'string' && value[:variable][:datastructure] == 'primitive'
                     'type_string'
                   else
                     "type_#{value[:variable][:datastructure]}"
                   end
        dtype = language[sig_type.to_s].to_s.gsub(/_/, cast_token(value[:variable][:dtype]))
        value.merge!(signature: "#{dtype} #{value[:name]}".strip)
      end
      var_data
    end

    def cast_token(dtype)
      dtype = dtype.capitalize if dtype == 'string'
      dtype
    end

    def create_class(type, conn)
      case type
      when 'int'
        "Integer#{conn}parseInt"
      when 'float'
        "Float#{conn}parseFloat"
      when 'long'
        "Long#{conn}parseLong"
      end
    end

    def linked_list_node_class
      ['static class Node{', "\tint data;", "\tNode next;", "\tNode(int data){", "\t\tthis.data = data;", "\t\tthis.next = null;", "\t}", '}']
    end

    def linked_list_convert_function
      ['static Node convertToLL(int arr[]){', "\tNode head = null;", "\tNode tail = null;", "\tint n = arr.length;", "\tfor (int i = 0; i < n ; i++){", "\t\tNode temp = new Node(arr[i]);",
       "\t\tif (head == null){", "\t\t\thead = temp;", "\t\t\ttail = temp;", "\t\t\t}", "\t\telse{", "\t\t\ttail.next = temp;", "\t\t\ttail = tail.next;", "\t\t}", "\t}", 'return head;', '}']
    end

    def linked_list_print_function
      ['static void printLL(Node head){', "\twhile (head != null){", "\t\tSystem.out.print(head.data + \" \");", "\t\thead = head.next;", "\t}", '}']
    end

    def tree_driver_code
      ["static class TreeNode {", "\t\tint val;", "\t\tTreeNode left;", "\t\tTreeNode right;", "\t\tTreeNode() {", "\t\t\tthis.val = 0;", "\t\t\tthis.left = null;", "\t\t\tthis.right = null;", "\t\t}", "\t\t", "\t\tTreeNode(int val) {", "\t\t\tthis.val = val;", "\t\t\tthis.left = null;", "\t\t\tthis.right = null;", "\t\t}", "\t\t", "\t\tTreeNode(int val, TreeNode left, TreeNode right) {", "\t\t\tthis.val = val;", "\t\t\tthis.left = left;", "\t\t\tthis.right = right;", "\t\t}", "\t\t", "\t\tTreeNode createBinaryTree(String[] arr) {", "\t\t\tif(arr.length == 0)", "\t\t\t\treturn null;", "\t\t\t", "\t\t\tQueue<TreeNode> q= new LinkedList<>();", "\t\t\tTreeNode root = new TreeNode(Integer.parseInt(arr[0]));", "\t\t\tq.add(root);", "\t\t\t", "\t\t\tint i = 1;", "\t\t\t", "\t\t\twhile(!q.isEmpty() && i < arr.length) {", "\t\t\t\tTreeNode curr = q.remove();", "\t\t", "\t\t\t\tif(!arr[i].equals(\"null\")) {", "\t\t\t\t\tcurr.left = new TreeNode(Integer.parseInt(arr[i]));", "\t\t\t\t\tq.add(curr.left);", "\t\t\t\t}", "\t\t\t\t", "\t\t\t\ti += 1;", "\t\t\t\t", "\t\t\t\tif(i == arr.length)", "\t\t\t\t\tbreak;", "\t\t\t\t", "\t\t\t\tif(!arr[i].equals(\"null\")) {", "\t\t\t\t\tcurr.right = new TreeNode(Integer.parseInt(arr[i]));", "\t\t\t\t\tq.add(curr.right);", "\t\t\t\t}", "\t\t\t\t", "\t\t\t\ti += 1;", "\t\t\t}", "\t\t", "\t\t\treturn root;", "\t\t}", "\t\t", "\t\tvoid trimNull(ArrayList<String> res) {", "\t\t\tint i=res.size()-1;", "\t\t\twhile(i>=0 && res.get(i).equals(\"null\"))\t{", "\t\t\t\tres.remove(i);", "\t\t\t\ti--;", "\t\t\t}", "\t\t}", "\t\t\t", "\t\tArrayList<String> parseTree(TreeNode root)   {", "\t\t\tArrayList<String> res = new ArrayList<String>();", "\t\t\tif(root == null)\treturn res;", "\t\t\t", "\t\t\tQueue<TreeNode> q = new LinkedList<>();", "\t\t\tq.add(root);", "\t\t\tres.add(Integer.toString(root.val));", "\t\t\twhile(!q.isEmpty())  {", "\t\t\t\tTreeNode curr = q.remove();", "\t\t\t\tif(curr.left != null)   {", "\t\t\t\t\tq.add(curr.left);", "\t\t\t\t\tres.add(Integer.toString(curr.left.val));", "\t\t\t\t}else   {", "\t\t\t\t\tres.add(\"null\");", "\t\t\t\t}", "\t\t\t\t", "\t\t\t\tif(curr.right != null)  {", "\t\t\t\t\tq.add(curr.right);", "\t\t\t\t\tres.add(Integer.toString(curr.right.val));", "\t\t\t\t}else   {", "\t\t\t\t\tres.add(\"null\");", "\t\t\t\t}", "\t\t\t}", "\t\t\t", "\t\t\ttrimNull(res);", "\t\t\treturn res;", "\t\t}", "\t\t", "\t}"]
    end

    def input_builder(name, datastructure, dtype, dependent)
      meta = {
        'primitive' => {
          'int' => ["#{name} = #{create_class('int', '.')}(bufferedReader.readLine().trim());"],
          'float' => ["#{name} = #{create_class('float', '.')}(bufferedReader.readLine().trim());"],
          'string' => ["#{name} = bufferedReader.readLine().trim();"]
        },
        'array' => {
          'int' => ["#{name} = new int[#{dependent&.first}];", "#{name} = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToInt(#{create_class('int', '::')}).toArray();"],
          'float' => ["#{name} = new float[#{dependent&.first}];",
                      "#{name} = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToFloat(#{create_class('float', '::')}).toArray();"],
          'string' => ["#{name} = new String[#{dependent&.first}];", "#{name} = bufferedReader.readLine().trim().split(\"\\\\s\");"]
        },
        'matrix' => {
          'int' => ['int mat_dims[] = new int[2];', "mat_dims = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToInt(#{create_class('int', '::')}).toArray();", "#{name} = new int[#{dependent&.first}][#{dependent&.second}];", "for(int i=0;i<#{dependent&.first};i++){",
                    "#{name}[i] = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToInt(#{create_class('int', '::')}).toArray();", '}'],
          'float' => ['int mat_dims[] = new int[2];', "mat_dims = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToInt(#{create_class('int', '::')}).toArray();", "#{name} = new float[#{dependent&.first}][#{dependent&.second}];", "for(int i=0;i<#{dependent&.first};i++){",
                      "#{name}[i] = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToFloat(#{create_class('float', '::')}).toArray();", '}'],
          'string' => ['int mat_dims[] = new int[2];', "mat_dims = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToInt(#{create_class('int', '::')}).toArray();", "#{name} = new String[#{dependent&.first}][#{dependent&.second}];", "for(int i=0;i<#{dependent&.first};i++){",
                       "#{name}[i] = bufferedReader.readLine().trim().split(\"\\\\s\");", '}']
        },
        'linked_list' => {
          'int' => ["int[] #{name}_raw_array = Arrays.stream(bufferedReader.readLine().trim().split(\"\\\\s\")).mapToInt(#{create_class('int', '::')}).toArray();", "#{name} = convertToLL(#{name}_raw_array);"]
        },
        'binary_tree' => {
          'int' => ["String #{name}_raw_str = bufferedReader.readLine().trim();", "String[] #{name}_raw_array = #{name}_raw_str.split(\" \");", "#{name} = new TreeNode();", "#{name} = #{name}.createBinaryTree(#{name}_raw_array);"]
        }
      }
      meta[datastructure][dtype]
    end

    def output_builder(name, datastructure, dtype)
      meta = {
        'primitive' => {
          'int' => ["System.out.println(#{name});"],
          'float' => ["System.out.println(#{name});"],
          'string' => ["System.out.println(#{name});"]
        },
        'array' => {
          'int' => ["System.out.println(Arrays.toString(#{name}).replaceAll(\"\\\\[|\\\\]|,\", \"\"));"],
          'float' => ["System.out.println(Arrays.toString(#{name}).replaceAll(\"\\\\[|\\\\]|,\", \"\"));"],
          'string' => ["System.out.println(Arrays.toString(#{name}).replaceAll(\"\\\\[|\\\\]|,\", \"\"));"]
        },
        'matrix' => {
          'int' => ["for (int i = 0; i < #{name}.length; i++){", "System.out.println(Arrays.toString(#{name}[i]).replaceAll(\"\\\\[|\\\\]|,\", \"\"));", '}'],
          'float' => ["for (int i = 0; i < #{name}.length; i++){", "System.out.println(Arrays.toString(#{name}[i]).replaceAll(\"\\\\[|\\\\]|,\", \"\"));", '}'],
          'string' => ["for (int i = 0; i < #{name}.length; i++){", "System.out.println(Arrays.toString(#{name}[i]).replaceAll(\"\\\\[|\\\\]|,\", \"\"));", '}']
        },
        'linked_list' => {
          'int' => ["printLL(#{name});"]
        },
        'binary_tree' => {
          'int' => ["ArrayList<String> #{name}_arr = #{name}.parseTree(#{name});", "for(String s:#{name}_arr)    {", "System.out.print(s + \" \");", "}"]
        }
      }
      meta[datastructure][dtype]
    end

    def build_head
      head_code = [
        'import java.io.*;',
        'import java.math.*;',
        'import java.security.*;',
        'import java.text.*;',
        'import java.util.*;',
        'import java.util.concurrent.*;',
        'import java.util.function.*;',
        'import java.util.regex.*;',
        'import java.util.stream.*;',
        'import java.util.Queue;',
        'import java.util.LinkedList;',
        'import java.util.ArrayList;',
        'import java.util.List;',
        'import static java.util.stream.Collectors.joining;',
        'import static java.util.stream.Collectors.toList;',
        'public class Main {'
      ]

      if @topic == 'linkedlist'
        head_code += linked_list_node_class
        head_code += linked_list_convert_function
        head_code += linked_list_print_function
      elsif @topic == 'tree'
        head_code += tree_driver_code
      end
      head_code.join("\n")
    end

    def build_body
      "static #{get_return_type.join(', ')} solve(#{build_parameter_list.join(', ')}){\n//CODE HERE \n}"
    end

    def build_tail
      tail_code = []

      tail_code << 'public static void main(String[] args) throws Exception{'
      tail_code << 'BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));'
      tail_code += get_input_signature.map { |signature| "#{signature};" }
      tail_code += input_code
      tail_code << "#{get_output_signature.join(', ')} = solve(#{build_argument_list.join(', ')});"
      tail_code += output_code

      tail_code += ['}', '}']

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
end

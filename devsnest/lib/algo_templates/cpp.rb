# frozen_string_literal: true

require 'algo_templates/base_helper'
module Templates
  class CPP < Templates::BaseHelper
    def initialize(input_json, output_json, topic)
      super(input_json, output_json, 'cpp')
      @topic = topic

      @head = build_head
      @body = build_body
      @tail = build_tail
    end

    def build_head
      head_code = ['#include<bits/stdc++.h>', 'using namespace std;']
      if @topic == 'linkedlist'
        head_code += linked_list_node_class
        head_code += linked_list_convert_function
        head_code += linked_list_print_function
      end
      head_code.join("\n")
    end

    def build_body
      "#{get_return_type.join(', ')} solve(#{build_parameter_list.join(', ')}){\n//CODE HERE \n}"
    end

    def build_tail
      tail_code = []

      tail_code << 'int main(){'
      tail_code += get_input_signature.map { |signature| "#{signature};" }
      tail_code += input_code
      tail_code << "#{get_output_signature.join(', ')} = solve(#{build_argument_list.join(', ')});"
      tail_code += output_code
      tail_code += ['return 0;', '}']
      tail_code.join("\n")
    end

    def linked_list_node_class
      ['struct Node {', "\tint data;", "\tstruct Node *next;", '};']
    end

    def linked_list_convert_function
      ['Node *convertToLL(vector<int> arr){', "\tint n = arr.size();", "\tNode *head = NULL;", "\tNode *tail = NULL;", "\tfor (int i = 0; i < n; i++){", "\t\tNode *temp = new Node;",
       "\t\ttemp->data = arr[i];", "\t\tif (head == NULL){", "\t\thead = temp;", "\t\ttail = temp;", "\t}", "\telse{", "\t\ttail->next = temp;", "\t\ttail = tail->next;", "\t}", '}', 'return head;', '}']
    end

    def linked_list_print_function
      ['void printLL(Node *head){', "\twhile (head != NULL){", "\t\tcout << head->data << ' ';", "\t\thead = head->next;", "\t}", '}']
    end

    def read_vector_function(type)
      ["vector<#{type}> read_vector_#{type}(){", "\tstring line = \"\";", "\tgetline(cin, line);", "\tistringstream iss(line);", "\tvector<#{type}> v;", "\t#{type} x;", "\twhile (iss >> x)", "\t\tv.push_back(x);", "\treturn v;", "}"]
    end

    def input_builder(name, datastructure, dtype, dependent)
      meta = {
        'primitive' => {
          'int' => ["cin >> #{name};"],
          'float' => ["cin >> #{name};"],
          'string' => ["getline(cin,#{name});"]
        },
        'array' => {
          'int' => ["string line = \"\";", "getline(cin, line);", "istringstream iss(line);", "int x;", "while (iss >> x)", "\t#{name}.push_back(x);"],
          'float' => ["string line = \"\";", "getline(cin, line);", "istringstream iss(line);", "float x;", "while (iss >> x)", "\t#{name}.push_back(x);"],
          'string' => ["string line = \"\";", "getline(cin, line);", "istringstream iss(line);", "string x;", "while (iss >> x)", "\t#{name}.push_back(x);"],
        },
        'matrix' => {
          'int' => ["#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'int temp;', 'cin >> temp;',
                    "#{name}[r].push_back(temp);", '}', '}'],
          'float' => ["#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'float temp;', 'cin >> temp;',
                      "#{name}[r].push_back(temp);", '}', '}'],
          'string' => ["#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'string temp;',
                       'getline(cin, temp);', "#{name}[r].push_back(temp);", '}', '}']
        },
        'linked_list' => {
          'int' => ['vector<int> raw_array;', "for (int i = 0; i < #{dependent&.first}; i++){", 'int temp;', 'cin >> temp;', 'raw_array.push_back(temp);', '}', "#{name} = convertToLL(raw_array);"]
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
        },
        'linked_list' => {
          'int' => ["printLL(#{name});"]
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

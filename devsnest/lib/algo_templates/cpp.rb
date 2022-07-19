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
      elsif @topic == 'tree'
        head_code += tree_driver_code
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
      ["vector<#{type}> read_vector_#{type}(){", "\tstring line = \"\";", "\tgetline(cin, line);", "\tistringstream iss(line);", "\tvector<#{type}> v;", "\t#{type} x;", "\twhile (iss >> x)",
       "\t\tv.push_back(x);", "\treturn v;", '}']
    end

    def tree_driver_code
      ["class TreeNode {", "\tpublic:", "\t\tint val;", "\t\tTreeNode *left;", "\t\tTreeNode *right;", "\tpublic:", "\t\tTreeNode() {", "\t\t\tthis->val = 0;", "\t\t\tthis->left = NULL;", "\t\t\tthis->right = NULL;", "\t\t}", "\t\tTreeNode(int val) {", "\t\t\tthis->val = val;", "\t\t\tthis->left = NULL;", "\t\t\tthis->right = NULL;", "\t\t}", "\t\tTreeNode(int val, TreeNode *left, TreeNode *right) {", "\t\t\tthis->val = val;", "\t\t\tthis->left = left;", "\t\t\tthis->right = right;", "\t\t}", "\t\tTreeNode* createBinaryTree(vector<string> &v1) {", "\t\t\tif(v1.size() == 0)", "\t\t\t\treturn NULL;", "\t\t\tqueue<TreeNode*> q1;", "\t\t\tTreeNode *root = new TreeNode(stoi(v1[0]));", "\t\t\tq1.push(root);", "\t\t\tint i = 1;", "\t\t\twhile(q1.size() && i < v1.size()) {", "\t\t\t\tTreeNode *curr = q1.front();", "\t\t\t\tq1.pop();", "if(v1[i] != \"null\") {", "\t\t\t\t\tcurr->left = new TreeNode(stoi(v1[i]));", "\t\t\t\t\tq1.push(curr->left);", "\t\t\t\t}", "\t\t\t\ti += 1;", "\t\t\t\tif(i == v1.size())", "\t\t\t\t\tbreak;", "\t\t\t\tif(v1[i] != \"null\") {", "\t\t\t\t\tcurr->right = new TreeNode(stoi(v1[i]));", "\t\t\t\t\tq1.push(curr->right);", "\t\t\t\t}", "\t\t\t\ti += 1;", "\t\t\t}", "\t\t\treturn root;", "\t\t}", "\t\tvector<string> parseTree(TreeNode *root) {", "\t\t\tif(!root)", "\t\t\t\treturn {};", "\t\t\tqueue<TreeNode*> q1;", "\t\t\tvector<string> res;", "\t\t\tq1.push(root);", "\t\t\tres.push_back(to_string(root->val));", "\t\t\twhile(q1.size()) {", "\t\t\t\tTreeNode *curr = q1.front();", "\t\t\t\tq1.pop();", "\t\t\t\tif(curr->left){", "\t\t\t\t\tq1.push(curr->left);", "\t\t\t\t\tres.push_back(to_string(curr->left->val));", "\t\t\t\t} else {", "\t\t\t\t\tres.push_back(\"null\");", "\t\t\t\t}", "\t\t\t\tif(curr->right) {", "\t\t\t\t\tq1.push(curr->right);", "\t\t\t\t\tres.push_back(to_string(curr->right->val));", "\t\t\t\t} else {", "\t\t\t\t\tres.push_back(\"null\");", "\t\t\t\t}", "\t\t\t}", "\t\t\ttrimNull(res);", "\t\t\treturn res;","\t\t}", "\tprivate:", "\t\tvoid trimNull(vector<string> &v1) {", "\t\t\tfor(int i = v1.size() - 1; i >= 0; i--) {", "\t\t\t\tif(v1[i] == \"null\")", "\t\t\t\t\tv1.pop_back();", "\t\t\t\telse", "\t\t\t\t\tbreak;", "\t\t\t}", "\t\t}", "};"]
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
          'int' => ['vector<int> mat_dims(2);', 'for(int i = 0; i < 2; i++){', 'cin >> mat_dims[i];', '}', "#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'int temp;', 'cin >> temp;',
                    "#{name}[r].push_back(temp);", '}', '}'],
          'float' => ['vector<int> mat_dims(2);', 'for(int i = 0; i < 2; i++){', 'cin >> mat_dims[i];', '}', "#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'float temp;', 'cin >> temp;',
                      "#{name}[r].push_back(temp);", '}', '}'],
          'string' => ['vector<int> mat_dims(2);', 'for(int i = 0; i < 2; i++){', 'cin >> mat_dims[i];', '}', "#{name}.resize(#{dependent&.first});", "for (int r = 0; r < #{dependent&.first}; r++){", "for (int c = 0; c < #{dependent&.second}; c++){", 'string temp;',
                        'cin >> temp;', "#{name}[r].push_back(temp);", '}', '}']
        },
        'linked_list' => {
          'int' => ["string #{name}_raw_str;", "getline(cin, #{name}_raw_str);", "stringstream #{name}_raw_str_stream(#{name}_raw_str);", "vector<int> #{name}_raw_array;", "while(#{name}_raw_str_stream >> #{name}_raw_str){", "#{name}_raw_array.push_back(stoi(#{name}_raw_str));" ,"}","#{name} = convertToLL(#{name}_raw_array);"]
        },
        'binary_tree' => {
          'int' => ["string #{name}_raw_str;", "getline(cin, #{name}_raw_str);", "stringstream #{name}_raw_str_stream(#{name}_raw_str);", "vector<string> #{name}_raw_array;", "while(#{name}_raw_str_stream >> #{name}_raw_str){", "#{name}_raw_array.push_back(#{name}_raw_str);" ,"}", "#{name} = #{name}->createBinaryTree(#{name}_raw_array);"]
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
          'int' => ["for (int r = 0; r < #{name}.size(); r++){", "for (int c = 0; c < #{name}[r].size(); c++){", "cout << #{name}[r][c] << \" \";", '}', 'cout << endl; }'],
          'float' => ["for (int r = 0; r < #{name}.size(); r++){", "for (int c = 0; c < #{name}[r].size(); c++){", "cout << #{name}[r][c] << \" \";", '}', 'cout << endl; }'],
          'string' => ["for (int r = 0; r < #{name}.size(); r++){", "for (int c = 0; c < #{name}[r].size(); c++){", "cout << #{name}[r][c] << \" \";", '}', 'cout << endl; }']
        },
        'linked_list' => {
          'int' => ["printLL(#{name});"]
        },
        'binary_tree' => {
          'int' => ["vector<string> #{name}_arr = #{name}->parseTree(#{name});", "for(string &x: #{name}_arr){", "cout << x << endl;", "}"]
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

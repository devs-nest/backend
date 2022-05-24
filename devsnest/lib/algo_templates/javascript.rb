require 'algo_templates/base_helper'
class Templates::JavaScript < Templates::BaseHelper
  def initialize(input_json, output_json, topic)
    super(input_json, output_json, 'javascript')
    @topic = topic

    @head = build_head
    @body = build_body
    @tail = build_tail
  end

  def build_head
    head_code = [$s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: 'template_files/parserat.js').body.read]
    if @topic == 'linkedlist'
      head_code += linked_list_node_class
      head_code += linked_list_convert_function
      head_code += linked_list_print_function
    end
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
    tail_code += ['function main(inputs){', "let #{get_output_signature.join(', ')} = solve(...inputs)"]
    tail_code += output_code
    tail_code += ['}']

    tail_code.join("\n")
  end

  def linked_list_node_class
    ['class ListNode {', 'constructor(data) {', "\tthis.data = data", "\tthis.next = null", '}', '}']
  end

  def linked_list_convert_function
    ['function convertToLL(arr){', "\tlet head, tail, temp", "\tfor(let i=0; i < a.length; i++){", "\t\tif(!head){", "", "\t\thead = new Node(a[i]);", "\t\ttail = head;", "\t\t}", "\t\telse{", "\t\ttail.next = new Node(a[i]);", "\t\ttail = tail.next", "\t\t}", "\t}", "return head;}"]
  end

  def linked_list_print_function
    ['function printLL(head){', 'let s = "";', "\twhile (head){", "\t\ts += head.data;", "\t\thead = head.next", "\t}", "console.log(s)", "}"]
  end
end

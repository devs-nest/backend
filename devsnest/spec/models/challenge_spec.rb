require 'rails_helper'
require 'algo_templates/python3'
require 'algo_templates/javascript'
require 'algo_templates/java'
require 'algo_templates/cpp'

RSpec.describe Challenge, type: :model do
  context 'algo template specs' do
    context 'python3 template' do
      let(:user) { create(:user) }
      let!(:python3) { create(:language, judge_zero_id: 71, name: 'python3') }
      let(:question) do
        create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum', is_active: true,
                           input_format: [{ "name": 'n', "variable": { "dtype": 'int', "dependent": [], "datastructure": 'primitive' } }, { "name": 'arr', "variable": { "dtype": 'int', "dependent": ['n'], "datastructure": 'array' } }],
                           output_format: [{ "name": 'out', "variable": { "dtype": 'int', "datastructure": 'array' } }])
      end

      it 'should create a template for python3' do
        algo_template = Templates::Python3.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).to eq('')
      end
    end

    context 'java template' do
      let(:user) { create(:user) }
      let!(:java) { create(:language, judge_zero_id: 4, name: 'java', type_array: '_[]', type_matrix: '_[][]', type_string: 'String', type_primitive: '_') }
      let(:question) do
        create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum', is_active: true,
                           input_format: [{ "name": 'n', "variable": { "dtype": 'int', "dependent": [], "datastructure": 'primitive' } }, { "name": 'arr', "variable": { "dtype": 'int', "dependent": ['n'], "datastructure": 'array' } }],
                           output_format: [{ "name": 'out', "variable": { "dtype": 'int', "datastructure": 'array' } }])
      end

      it 'should create a template for Java' do
        algo_template = Templates::Java.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).not_to be_empty
      end
    end

    context 'cpp template' do
      let(:user) { create(:user) }
      let!(:cpp) { create(:language, judge_zero_id: 5, name: 'cpp', type_array: 'vector<_>', type_matrix: 'vector>', type_string: '_', type_primitive: '_') }
      let(:question) do
        create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum', is_active: true,
                           input_format: [{ "name": 'n', "variable": { "dtype": 'int', "dependent": [], "datastructure": 'primitive' } }, { "name": 'arr', "variable": { "dtype": 'int', "dependent": ['n'], "datastructure": 'array' } }],
                           output_format: [{ "name": 'out', "variable": { "dtype": 'int', "datastructure": 'array' } }])
      end

      it 'should create a template for CPP' do
        algo_template = Templates::CPP.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).not_to be_empty
      end
    end
  end
end

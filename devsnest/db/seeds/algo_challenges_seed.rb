# frozen_string_literal: true

langs = %w[python3 cpp java javascript]

Language.find_or_create_by(judge_zero_id: 71, name: 'python3', type_array: '', type_matrix: '', type_string: '', type_primitive: '') if Language.find_by_judge_zero_id(71).nil?
Language.find_or_create_by(judge_zero_id: 70, name: 'python2', type_array: '', type_matrix: '', type_string: '', type_primitive: '') if Language.find_by_judge_zero_id(70).nil?
Language.find_or_create_by(judge_zero_id: 63, name: 'javascript', type_array: '', type_matrix: '', type_string: '', type_primitive: '') if Language.find_by_judge_zero_id(63).nil?
if Language.find_by_judge_zero_id(54).nil?
  Language.find_or_create_by(judge_zero_id: 54, name: 'cpp', type_array: 'vector<_>', type_matrix: 'vector<vector<_>>', type_string: '_',
                             type_primitive: '_')
end
Language.find_or_create_by(judge_zero_id: 62, name: 'java', type_array: '_[]', type_matrix: '_[][]', type_string: 'String', type_primitive: '_') if Language.find_by_judge_zero_id(62).nil?

Challenge.find_or_create_by(topic: 1, difficulty: 1, name: '2 sum?', question_body: '# Heading', is_active: true, input_format: {
                              0 => {
                                "name": 'n',
                                "variable": {
                                  "datastructure": 'primitive',
                                  "dtype": 'int',
                                  "dependent": []
                                }
                              },
                              1 => {
                                "name": 'arr',
                                "variable": {
                                  "datastructure": 'array',
                                  "dtype": 'int',
                                  "dependent": [
                                    'n'
                                  ]
                                }
                              },

                              2 => {
                                "name": 'mat',
                                "variable": {
                                  "datastructure": 'matrix',
                                  "dtype": 'int',
                                  "dependent": %w[
                                    n
                                    m
                                  ]
                                }
                              }

                            },
                            output_format: {
                              0 =>
                                  {
                                    "name": 'out',
                                    "variable": {
                                      "datastructure": 'array',
                                      "dtype": 'int'
                                    }
                                  }
                            })

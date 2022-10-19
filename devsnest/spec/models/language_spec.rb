# == Schema Information
#
# Table name: languages
#
#  id                   :bigint           not null, primary key
#  language_description :string(255)
#  memory_limit         :string(255)
#  name                 :string(255)
#  time_limit           :string(255)
#  type_array           :string(255)      default("")
#  type_binary_tree     :string(255)
#  type_linked_list     :string(255)
#  type_matrix          :string(255)      default("")
#  type_primitive       :string(255)      default("")
#  type_string          :string(255)      default("")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  judge_zero_id        :integer
#
require 'rails_helper'

RSpec.describe Language, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: college_structure_mappings
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  college_profile_id   :bigint           not null
#  college_structure_id :bigint           not null
#
# Indexes
#
#  index_college_structure_mappings_on_college_profile_id    (college_profile_id)
#  index_college_structure_mappings_on_college_structure_id  (college_structure_id)
#
# Foreign Keys
#
#  fk_rails_...  (college_profile_id => college_profiles.id)
#  fk_rails_...  (college_structure_id => college_structures.id)
#
class CollegeStructureMapping < ApplicationRecord
  belongs_to :college_profile
  belongs_to :college_structure
end

class CollegeStructure < ApplicationRecord
  many_to_many :college_profiles, through: :college_structure_mappings
end

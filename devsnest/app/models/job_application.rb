class JobApplication < ApplicationRecord
  belongs_to :users
  belongs_to :job

  enum status: %i[applied interview offer rejected]
end

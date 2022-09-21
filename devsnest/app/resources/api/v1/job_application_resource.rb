module Api
  module V1
    class JobApplicationResource < JSONAPI::Resource
      attributes :user_id, :job_id, :status, :email, :phone_number, :note_for_the_recruiter, :created_at, :updated_at
    end
  end
end

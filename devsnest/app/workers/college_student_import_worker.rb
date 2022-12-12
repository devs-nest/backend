# frozen_string_literal: true

class CollegeStudentImportWorker
  include Sidekiq::Worker

  def perform(file, college_id)
    invalid_students = {}
    CSV.foreach(file, headers: true) do |row|
      begin
        email = row['Email']
        department = row['Department']
        authority_level = row['Authority Level']
        user_id = User.find_by(email: email)&.id
        template_id = EmailTemplate.find_by(name: 'college_join')&.template_id
        data_to_encode = {
          email: email,
          initiated_at: Time.now
        }
        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)
        if CollegeProfile.create!(user_id: user_id, college_id: college_id, email: email, department: department, authority_level: authority_level)
          EmailSenderWorker.perform_async(email, {
                                            code: encrypted_code
                                          }, template_id)
        end
      rescue => e
        invalid_students << { email: email, error: e }
      end
    end
    invalid_students
  end
end

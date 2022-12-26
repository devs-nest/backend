# frozen_string_literal: true

class CollegeStudentImportWorker
  include Sidekiq::Worker

  def perform(file, college_id, stucture = nil)
    invalid_students = {}
    template_id = EmailTemplate.find_by(name: 'college_join')&.template_id
    c_struc = CollegeStructure.find_by_name(stucture)
    CSV.foreach(file, headers: true) do |row|
      begin
        email = row['Email']
        department = row['Department']
        authority_level = row['Authority Level']

        user = User.find_by_email(email)
        skip_pass = user.blank?

        data_to_encode = {
          email: email,
          initiated_at: Time.now
        }
        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)


        ActiveRecord::Base.transaction do
          college_profile = CollegeProfile.create!(email: email, college_id: college_id, college_structure_id: c_struc&.id, authority_level: authority_level)
          CollegeInvite.create!(college_profile: college_profile, uid: encrypted_code, college_id: college_id)

          EmailSenderWorker.perform_async(email, {
                                            collegename: user.college.name,
                                            username: email.split("@")[0],
                                            code: encrypted_code,
                                            skip_pass: skip_pass
                                          }, template_id)
        end
      rescue => e
        invalid_students << { email: email, error: e }
      end
    end
    invalid_students
  end
end

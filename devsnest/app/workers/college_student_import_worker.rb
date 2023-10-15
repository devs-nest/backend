# frozen_string_literal: true

class CollegeStudentImportWorker
  include Sidekiq::Worker

  def perform(key, college_id, stucture = nil)
    invalid_students = []
    file = $s3.get_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key).body.string
    template_id = EmailTemplate.find_by(name: 'college_join_lm')&.template_id
    c_struc = CollegeStructure.find_by_name(stucture)

    CSV.parse(file.strip)[1..].each do |row|
      begin
        email = row[0]
        roll_number = row[1]

        user = User.find_by_email(email)
        skip_pass = user.blank?

        data_to_encode = {
          email: email,
          roll_number: roll_number,
          initiated_at: Time.now
        }
        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)


        ActiveRecord::Base.transaction do
          college_profile = CollegeProfile.create!(email: email, college_id: college_id, college_structure_id: c_struc&.id,
                                                   roll_number: roll_number, authority_level: 'student')
          CollegeInvite.create!(college_profile: college_profile, uid: encrypted_code, college_id: college_id)

          EmailSenderWorker.perform_async(email, {
                                            collegename: college_profile.college.name,
                                            username: email.split("@")[0],
                                            code: encrypted_code,
                                            skip_pass: skip_pass
                                          }, template_id)
        end
      rescue => e
        invalid_students << { email: email, error: e }
      end
    end
    # cleanup
    $s3.delete_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key)
    invalid_students
  end
end

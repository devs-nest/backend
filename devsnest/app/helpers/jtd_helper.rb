require 'zip'

module JtdHelper
  def self.jtd_user_progress(date_range)
    groups = Group.jtd
    current_course = Course.last
    course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
    csvs = []
    gids = []

    rows = ['user_id', 'username' 'dsa_attempted', 'dsa_solved', 'dsa_new_solved', 'fe_attempted', 'fe_solved', 'fe_new_solved', 'be_attempted', 'be_solved', 'be_new_solved']
    groups.each do |group|
      csv = []
      csv << rows
      group.group_members.each do |gu|
        user = gu.user
        dsa_solved_count = UserChallengeScore.where(user_id: user.id, updated_at: date_range).where('passed_test_cases = total_test_cases').count
        dsa_attempted_count = UserChallengeScore.where(user_id: user.id, updated_at: date_range).count
        dsa_new_count = UserChallengeScore.where(user_id: user.id, created_at: date_range).where('passed_test_cases = total_test_cases').count

        fe_solved_count = FrontendChallengeScore.where(user_id: user.id, updated_at: date_range).where('passed_test_cases = total_test_cases').count
        fe_attempted_count = FrontendChallengeScore.where(user_id: user.id, updated_at: date_range).count
        fe_new_count = FrontendChallengeScore.where(user_id: user.id, created_at: date_range).where('passed_test_cases = total_test_cases').count

        be_solved_count = BackendChallengeScore.where(user_id: user.id, updated_at: date_range).where('passed_test_cases = total_test_cases').count
        be_attempted_count = BackendChallengeScore.where(user_id: user.id, updated_at: date_range).count
        be_new_count = BackendChallengeScore.where(user_id: user.id, created_at: date_range).where('passed_test_cases = total_test_cases').count

        csv << [user.id, user.username, dsa_attempted_count, dsa_solved_count, dsa_new_count, fe_attempted_count, fe_solved_count, fe_new_count, be_attempted_count, be_solved_count, be_new_count]
      end
      gids << group.name
      csvs << csv
    end

    write_zip(csvs, gids, 'user_data')
  end

  def self.jtd_scrum_details(data_range)
    groups = Group.jtd
    head = Scrum.column_names
    csvs = []
    gids = []

    groups.each do |gu|
      csv = []
      csv << head
      scrums = Scrum.where(group_id: gu.id, updated_at: data_range).orders(updated_at: :desc)
      scrums.each do |scrum|
        csv << scrum.attributes.values
      end

      gids << gu.name
      csvs << csv
    end

    write_zip(csvs, gids, 'scrum_data')
  end

  def self.write_zip(csvs, gids, csv_key)
    key = "#{csv_key}-#{DateTime.now.to_i}.zip"
    zip = Zip::OutputStream.write_buffer do |zipfile|
      csvs.each_with_index do |csv_rows, index|
        csv_filename = "#{gids[index]}-#{DateTime.now.to_i}.csv"

        zipfile.put_next_entry(csv_filename)
        csv_string = CSV.generate { |csv| csv_rows.each { |row| csv << row } }
        zipfile.write(csv_string)
      end
    end.string

    bucket = "jtd-data"
    $s3.put_object(bucket: bucket, key: key, body: zip)
    "https://#{bucket}.s3.ap-south-1.amazonaws.com/#{key}"
  end
end

require 'zip'

module JtdHelper
  def self.jtd_user_progress(date_range, dstring)
    college_structure_path = '2024-2028/btech/cs'
    college = College.find_by_name('jtd')

    college_structure = CollegeStructure.where('college_id = ? AND name LIKE ?', college.id, "%#{college_structure_path}%")
    college_profiles = CollegeProfile.includes(:user).where(college_id: @college.id, college_structure_id: college_structure.pluck(:id), authority_level: 'student')
    current_course = Course.last
    course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
    current_module = current_course.current_module

    csv1 = []
    user_head = ['username', 'user email', 'dsa solved', 'frontend solved', 'backend solved']
    csv1 << user_head

    total_assignments_dsa_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge').pluck(:question_id).uniq
    total_assignments_fe_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'FrontendChallenge').pluck(:question_id).uniq
    total_assignments_be_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'BackendChallenge').pluck(:question_id).uniq

    college_profiles.joins(:user).select('users.id as user_id, users.username as username, users.email as email').each do |user|
      user_dsa_solved = UserChallengeScore.where(user_id: user.user_id, challenge_id: total_assignments_dsa_ids, updated_at: date_range).where('passed_test_cases = total_test_cases').count
      user_fe_solved = FrontendChallengeScore.where(user_id: user.user_id, challenge_id: total_assignments_fe_ids, updated_at: date_range).where('passed_test_cases = total_test_cases').count
      user_be_solved = BackendChallengeScore.where(user_id: user.user_id, challenge_id: total_assignments_be_ids, updated_at: date_range).where('passed_test_cases = total_test_cases').count
      csv1 << [user.username, user.email, user_dsa_solved, user_fe_solved, user_be_solved]
    end

    csv2 = []
    head = ['username', 'user email', 'date', 'dsa attempted', 'dsa solved', 'dsa new solved', 'frontend attempted', 'frontend solved', 'frontend new solved', 'backend attempted', 'backend solved', 'backend new solved']
    csv2 << head
    date_range.each do |day|
      college_profiles.joins(:user).order('users.username ASC').select('users.id as user_id, users.username as username, users.email as email').each do |gu|
        dsa_q = UserChallengeScore.where(user_id: gu.user_id, challenge_id: total_assignments_dsa_ids)
        dsa_solved_count = dsa_q.where(updated_at: day.beginning_of_day..day.end_of_day).where('passed_test_cases = total_test_cases').count
        dsa_attempted_count = dsa_q.where(updated_at: day.beginning_of_day..day.end_of_day).count
        dsa_new_count = dsa_q.where(created_at: day.beginning_of_day..day.end_of_day).where('passed_test_cases = total_test_cases').count

        fe_q = FrontendChallengeScore.where(user_id: gu.user_id, challenge_id: total_assignments_fe_ids)
        fe_solved_count = fe_q.where(updated_at: day.beginning_of_day..day.end_of_day).where('passed_test_cases = total_test_cases').count
        fe_attempted_count = fe_q.where(updated_at: day.beginning_of_day..day.end_of_day).count
        fe_new_count = fe_q.where(created_at: day.beginning_of_day..day.end_of_day).where('passed_test_cases = total_test_cases').count

        be_q = BackendChallengeScore.where(user_id: gu.user_id, challenge_id: total_assignments_be_ids)
        be_solved_count = be_q.where(updated_at: day.beginning_of_day..day.end_of_day).where('passed_test_cases = total_test_cases').count
        be_attempted_count = be_q.where(updated_at: day.beginning_of_day..day.end_of_day).count
        be_new_count = be_q.where(created_at: day.beginning_of_day..day.end_of_day).where('passed_test_cases = total_test_cases').count

        csv2 << [gu.username, gu.email, day, dsa_attempted_count, dsa_solved_count, dsa_new_count, fe_attempted_count, fe_solved_count, fe_new_count, be_attempted_count, be_solved_count, be_new_count]
      end
    end

    gids = ['user_details', 'user_daily_data']
    csvs = [csv1, csv2]
    write_zip(csvs, gids, 'user_details', dstring)
  end

  def self.jtd_scrum_details(date_range, dstring)
    groups = Group.jtd
    cols = Scrum.column_names - ['id', 'updated_at', 'created_at']
    head = cols.map(&:humanize)
    csvs = []
    gids = []

    groups.each do |gu|
      csv = []
      csv << head
      scrums = Scrum.where(group_id: gu.id, updated_at: date_range).joins('inner join users on users.id = scrums.user_id').select('scrums.*, users.username as username').order(updated_at: :desc)
      scrums.each do |scrum|
        req_fields = scrum.attributes.slice(*cols)
        req_fields['user_id'] = scrum.username
        req_fields['group_id'] = gu.name

        csv << req_fields.values
      end

      gids << gu.name
      csvs << csv
    end

    write_zip(csvs, gids, 'scrum_details', dstring)
  end

  def self.batch_leader_details(date_range, dstring)
    key = "batch-leader-#{dstring}-#{DateTime.current.to_date}.csv"
    bl_data = BatchLeaderSheet.joins("inner join `groups` on `groups`.`id` = `batch_leader_sheets`.`group_id`")
                    .joins("inner join `users` on `users`.`id` = `batch_leader_sheets`.`user_id`")
                    .where(groups: { bootcamp_type: 4 })
                    .where(creation_week: date_range)
                    .order({ user_id: :asc, creation_week: :desc })
                    .select("*, `users`.username as username, `groups`.`name` as groupname")
    cols = BatchLeaderSheet.column_names - ['id']
    head = cols.map(&:humanize) - ['Tl tha', 'Vtl tha'] + ['Team leader assignments', 'Vice team leader assignments']
    bcsv = []
    bcsv << head

    bl_data.each do |bld|
      req_fields = bld.attributes.slice(*cols)
      req_fields['user_id'] = bld.username
      req_fields['group_id'] = bld.groupname
      req_fields["active_members"] = req_fields["active_members"].try(:join, ', ')
      req_fields["par_active_members"] = req_fields["par_active_members"].try(:join, ', ')
      req_fields["inactive_members"] = req_fields["inactive_members"].try(:join, ', ')
      req_fields["doubt_session_taker"] = req_fields["doubt_session_taker"].try(:join, ', ')
      bcsv << req_fields.values
    end

    csv_string = CSV.generate { |csv| bcsv.each { |row| csv << row } }
    bucket = "jtd-data"
    $s3.put_object(bucket: bucket, key: key, body: csv_string)
    ["https://#{bucket}.s3.ap-south-1.amazonaws.com/#{key}", key]
  end

  def self.write_zip(csvs, gids, csv_key, dstring)
    range = range.to_a
    key = "#{csv_key}-#{dstring}-#{DateTime.current.to_date}.zip"
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
    ["https://#{bucket}.s3.ap-south-1.amazonaws.com/#{key}", key]
  end
end

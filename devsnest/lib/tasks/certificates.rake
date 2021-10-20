# frozen_string_literal: true

def type_to_title(type)
  case type
  when 'course_dsa'
    'DSA Course'
  when 'course_frontend'
    'Frontend Course'
  when 'course_backend'
    'Backend Course'
  when 'course_dsa_frontend_backend'
    'Devsnest Course'
  when 'community_batch_leader'
    'Batch Lead'
  when 'community_student_mentor'
    'Student Mentor'
  when 'community_moderator'
    'Community Moderator'
  else
    ''
  end
end

namespace :assign_certificate_to_user do
  begin
    file = File.open(Rails.root + 'storage/invalid_discord_id_certificates.txt', 'w')
  rescue IOError => e
    # some error occur, dir not writable etc.
  end
  desc 'Assign certificates to user'
  require 'csv'
  task Dsa_certificates: :environment do
    type = 'course_dsa'
    filename = File.join Rails.root, 'scripts/DSA_Course.csv'
    CSV.foreach(filename, headers: true) do |row|
      user = User.find_by(discord_id: row['discord_id'])
      if user.present?
        user.update(name: row['real_name'])
        Certification.create(user_id: user.id, certificate_type: type, title: type_to_title(type), cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
      else
        file.write(row['discord_id'], ' ', type)
        file.write "\n"
      end
    rescue StandardError
      puts row['discord_id']
    end
  end

  task Frontend_certificates: :environment do
    type = 'course_frontend'
    filename = File.join Rails.root, 'scripts/Frontend_Course.csv'
    CSV.foreach(filename, headers: true) do |row|
      user = User.find_by(discord_id: row['discord_id'])
      if user.present?
        user.update(name: row['real_name'])
        Certification.create(user_id: user.id, certificate_type: type, title: type_to_title(type), cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
      else
        file.write(row['discord_id'], ' ', type)
        file.write "\n"
      end
    rescue StandardError
      puts row['discord_id']
    end
  end

  task Backend_certificates: :environment do
    type = 'course_backend'
    filename = File.join Rails.root, 'scripts/Backend_Course.csv'
    CSV.foreach(filename, headers: true) do |row|
      user = User.find_by(discord_id: row['discord_id'])
      if user.present?
        user.update(name: row['real_name'])
        Certification.create(user_id: user.id, certificate_type: type, title: type_to_title(type), cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
      else
        file.write(row['discord_id'], ' ', type)
        file.write "\n"
      end
    rescue StandardError
      puts row['discord_id']
    end
  end

  task course_dsa_frontend_backend_certificates: :environment do
    type = 'course_dsa_frontend_backend'
    filename = File.join Rails.root, 'scripts/Full_Stack_Course.csv'
    CSV.foreach(filename, headers: true) do |row|
      user = User.find_by(discord_id: row['discord_id'])
      if user.present?
        user.update(name: row['real_name'])
        Certification.create(user_id: user.id, certificate_type: type, title: type_to_title(type), cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
      else
        file.write(row['discord_id'], ' ', type)
        file.write "\n"
      end
    rescue StandardError
      puts row['discord_id']
    end
  end

  task community_people_certificates: :environment do
    type = 'community'
    filename = File.join Rails.root, 'scripts/Community_people.csv'
    CSV.foreach(filename, headers: true) do |row|
      user = User.find_by(discord_id: row['discord_id'])
      if user.present?
        user.update(name: row['real_name'])
        case row['role']
        when 'Moderator '
          type = 'community_moderator'
        when 'Batch Leader '
          type = 'community_batch_leader'
        when 'Student Mentor'
          type = 'community_student_mentor'
        end
        Certification.create(user_id: user.id, certificate_type: type, title: type_to_title(type), cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
      else
        file.write(row['discord_id'], ' ', row['role'])
        file.write "\n"
      end
    rescue StandardError
      puts row['discord_id']
    end
  end

  task run_all_tasks: :environment do
    Rake.application.tasks.each do |task|
      task.invoke if task.name.starts_with?('assign_certificate_to_user:')
    end
  end
end

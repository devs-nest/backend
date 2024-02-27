# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                :bigint           not null, primary key
#  activity_point    :integer          default(0)
#  bootcamp_type     :integer          default("dsa")
#  classification    :integer          default("students")
#  description       :text(65535)
#  five_members_flag :boolean          default(FALSE)
#  group_type        :integer          default("public")
#  language          :integer          default("english")
#  members_count     :integer          default(0)
#  name              :string(255)      default(""), not null
#  scrum_end_time    :time             default(Sat, 01 Jan 2000 15:00:00.000000000 IST +05:30)
#  scrum_start_time  :time             default(Sat, 01 Jan 2000 14:30:00.000000000 IST +05:30)
#  slug              :string(255)
#  version           :integer          default(2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  batch_id          :integer
#  batch_leader_id   :integer
#  co_owner_id       :integer
#  owner_id          :integer
#  server_id         :integer          default(1)
#  student_mentor_id :integer
#
# Indexes
#
#  index_groups_on_members_count  (members_count)
#  index_groups_on_name           (name) UNIQUE
#  index_groups_on_slug           (slug) UNIQUE
#
include UtilConcern
# Model for Group
class Group < ApplicationRecord
  include UtilConcern
  # belongs_to :batch
  audited
  has_many :group_members, dependent: :destroy
  belongs_to :server
  belongs_to :course, optional: true
  after_create :parameterize
  before_create :assign_server
  after_commit :expire_cache
  validates :members_count, numericality: { less_than_or_equal_to: 20, message: 'The group is full' }
  validates :members_count, numericality: { greater_than_or_equal_to: 0, message: 'The group members count can\'t be negetive' }
  validates :name, length: { minimum: 4, maximum: 33, message: 'The group name must be between 4 and 25 characters' }
  validates_uniqueness_of :name, case_sensitive: true
  validates_uniqueness_of :slug, case_sensitive: true
  enum group_type: %i[public private], _prefix: :group
  enum language: %i[english hindi]
  enum classification: %i[students professionals]
  # Temporary change for adding JTD bootcamp type
  enum bootcamp_type: %i[dsa frontend backend solana jtd]

  has_paper_trail

  scope :v1, -> { where(version: 1) }
  scope :v2, -> { where(version: 2) }
  scope :visible, -> { where(group_type: 'public') }
  scope :under_limited_members, -> { where('members_count < 16') }
  scope :jtd, -> { where(bootcamp_type: 4) }

  def parameterize
    update_attribute(:slug, name.parameterize)
  end

  def assign_server
    server = Server.second || Server.last # TODO: Make this dynamic
    self.server_id = server&.id
  end

  def reassign_leader(user_id)
    if owner_id == user_id
      if co_owner_id.nil? && group_members.count.positive?
        promote_member_id = group_members.pluck(:user_id).sample
        update(owner_id: promote_member_id)
      elsif co_owner_id.present?
        update(owner_id: co_owner_id, co_owner_id: nil)
      else
        disband_group
      end
    elsif co_owner_id == user_id
      update(co_owner_id: nil)
    end
  end

  def self.merge_two_groups(group_1_id, group_2_id, preserved_group_id, options = {})
    group_1.paper_trail_event = 'merge_two_groups'
    group_2.paper_trail_event = 'merge_two_groups'
    group_1 = Group.find(group_1_id) # used find to throw error in case of invalid group id
    group_2 = Group.find(group_2_id) # used find to throw error in case of invalid group id
    group_to_be_destroyed_id = group_1_id == preserved_group_id ? group_2_id : group_1_id

    # Update all the existing tables with the new group id
    ActiveRecord::Base.transaction do
      group_to_be_destroyed = group_to_be_destroyed_id == group_2.id ? group_2 : group_1
      destroyed_group_user_ids = GroupMember.where(group_id: group_to_be_destroyed_id).pluck(:user_id)
      GroupMember.where(group_id: group_to_be_destroyed_id).update_all(group_id: preserved_group_id)
      BatchLeaderSheet.where(group_id: group_to_be_destroyed_id).update_all(group_id: preserved_group_id)
      WeeklyTodo.where(group_id: group_to_be_destroyed_id).update_all(group_id: preserved_group_id)

      preserved_group = Group.find(preserved_group_id) # used find to throw error in case of invalid group id
      new_group_name = options[:name] || group_1.name || group_2.name
      # Updating Group to be destroyed Name to avoid duplication issue
      group_to_be_destroyed_name = group_to_be_destroyed.name
      group_to_be_destroyed.update!(name: SecureRandom.hex(6).to_s)
      new_owner_id = options[:owner_id] || group_1.owner_id || group_2.owner_id
      new_co_owner_id = options[:co_owner_id] || group_1.co_owner_id || group_2.co_owner_id
      old_group_name = preserved_group.name
      preserved_group.update!(name: new_group_name, owner_id: new_owner_id, co_owner_id: new_co_owner_id)
      preserved_group.update!(members_count: preserved_group.group_members.count)
      # change tags for the group members
      discord_ids = []
      preserved_group.group_members.each do |member|
        discord_ids << User.find_by(id: member&.user_id)&.discord_id
      end
      discord_ids = discord_ids.compact.uniq

      destroyed_group_user_ids.each do |user_id|
        user = User.find_by(id: user_id)
        send_group_change_message(user, preserved_group)
      end
      # Sending new_group_name as a role tag to the discord ids
      if preserved_group&.server_id != group_to_be_destroyed&.server_id
        destroyed_discord_ids = User.where(id: destroyed_group_user_ids).pluck(:discord_id)
        MassRoleModifierWorker.perform_async('add_mass_role', destroyed_discord_ids, 'Devsnest People')
      end
      GroupModifierWorker.perform_async('update', [old_group_name, new_group_name], group.bootcamp_type, preserved_group.server.guild_id) if old_group_name != new_group_name
      MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, new_group_name, preserved_group&.server&.guild_id)
      GroupModifierWorker.perform_async('destroy', [group_to_be_destroyed_name], group.bootcamp_type, group_to_be_destroyed&.server&.guild_id)
      # Is This required
      MassRoleModifierWorker.perform_async('delete_role', destroyed_discord_ids, group_to_be_destroyed_name, group_to_be_destroyed&.server&.guild_id)
      group_to_be_destroyed.destroy
    end
  rescue StandardError
    false
  else
    true
  end

  def disband_group
    destroy
  end

  def promote_to_tl(user_id)
    self.paper_trail_event = 'promote_to_tl'
    if co_owner_id == user_id
      update(owner_id: co_owner_id, co_owner_id: owner_id)
    else
      update(owner_id: user_id)
    end
  end

  def promote_to_vtl(user_id)
    self.paper_trail_event = 'promote_to_vtl'
    if owner_id == user_id
      update(owner_id: co_owner_id, co_owner_id: owner_id)
    else
      update(co_owner_id: user_id)
    end
  end

  def check_auth(user)
    return true if group_members.where(user_id: user.id).present? || batch_leader_id == user.id || user.user_type == 'admin'

    false
  end

  def group_admin_auth(user)
    return true if user.id == owner_id || user.id == co_owner_id || user.user_type == 'admin'

    false
  end

  def admin_rights_auth(user)
    return true if user.id == owner_id || user.id == co_owner_id || user.id == batch_leader_id || user.user_type == 'admin'

    false
  end

  def invite_inactive_members
    group_members.each do |member|
      server_user = ServerUser.find_by(user_id: member.user_id, server_id: server_id)
      send_group_change_message(member, @model) unless server_user.present?
    end
  end

  def weekly_data
    current_course = course || Course.first # Adding Course.first for handling old groups
    course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
    scrum_data = Scrum.where(creation_date: Date.today.last_week.beginning_of_week..Date.today.last_week.end_of_week, group_id: id)
    total_scrums = scrum_data.pluck(:creation_date).uniq.compact.count
    result = []
    current_module = current_course.current_module
    group_members.each do |gm|
      user = User.find_by(id: gm&.user_id)
      next unless user.present?

      user_scrums_count = scrum_data.where(user_id: user.id).count
      scrum_attended = scrum_data.where(user_id: user.id, attendance: true).count

      case current_module
      when 'dsa'
        total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge').pluck(:question_id).uniq
        solved_assignments_count = UserChallengeScore.where(user_id: user.id, challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count

        recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge')
                                                            .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id).uniq
        recent_solved_assignments_count = UserChallengeScore.where(user_id: user.id, challenge_id: recent_total_assignments_ch_ids).where('passed_test_cases = total_test_cases').count
      when 'frontend'
        total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'FrontendChallenge').pluck(:question_id).uniq
        solved_assignments_count = FrontendChallengeScore.where(user_id: user.id, frontend_challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count

        recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'FrontendChallenge')
                                                            .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id).uniq
        recent_solved_assignments_count = FrontendChallengeScore.where(user_id: user.id, frontend_challenge_id: recent_total_assignments_ch_ids).where('passed_test_cases = total_test_cases').count
      when 'backend'
        total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'BackendChallenge').pluck(:question_id).uniq
        solved_assignments_count = BackendChallengeScore.where(user_id: user.id, backend_challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count

        recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'BackendChallenge')
                                                            .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id).uniq
        recent_solved_assignments_count = BackendChallengeScore.where(user_id: user.id, backend_challenge_id: recent_total_assignments_ch_ids).where('passed_test_cases = total_test_cases').count
      end

      result.append({
                      user_name: user.name,
                      total_group_scrums: total_scrums,
                      user_scrums_count: user_scrums_count,
                      scrum_attended_count: scrum_attended,
                      scrum_absent: user_scrums_count - scrum_attended,
                      class_rating_count: scrum_data.where.not(class_rating: nil).count,
                      tha_progress_count: scrum_data.where.not(tha_progress: nil).count,
                      topics_to_cover_count: scrum_data.where.not(topics_to_cover: nil).count,
                      solved_assignments_count: solved_assignments_count,
                      recent_solved_assignments_count: recent_solved_assignments_count
                    })
    end
    result
  end

  def count_activity_point
    Scrum.where('group_id = ? and created_at > ?', id, (Date.today - 6.days).beginning_of_day).group(:creation_date).having('count(attendance) >= ?', members_count * 0.3).count.count
  end

  def self.eligible_groups
    where("version = 2 AND group_type = 'public' AND members_count < 16")
  end
end

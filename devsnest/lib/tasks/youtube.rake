# frozen_string_literal: true

namespace :youtube_link do
  desc 'import youtube data from a csv file'
  require 'csv'
  task data: :environment do
    filename = File.join Rails.root, 'scripts/youtube_sheet.csv'
    # header remove
    # Unique Id,Parent,Yname,Ylink,Qid,class,class-diff,assignment,assign-diff,REF
    # Content.create(unique_id: 'link3', parent_id: 'bst', name: 'yt_link3', data_type: 1, link: 'https://youtube.com/sometingsss', priority: 4, video_questions: [9,10])
    CSV.foreach(filename, headers: true) do |row|
      link_id = row[0]
      if link_id.present?
        t = Content.create(unique_id: link_id, parent_id: row[1], name: row[2], data_type: 1, link: row[3])
        t.priority = t.id
        t.video_questions = row[4].split('/').map(&:to_i) if row[4].present?
        t.reference_data = JSON.parse(row[9]) if row[9].present?
        t.save
      else
        t = Content.where(data_type: 1).last
      end
      quest_link = row[5]
      if quest_link.present?
        question_name = create_name(quest_link)
        c = Content.create(name: question_name, parent_id: t.parent_id, link: quest_link, data_type: 0)
        c.unique_id = "Q#{c.id}"
        c.difficulty = row[6].downcase
        c.priority = c.id
        c.question_type = 'class'
        t.video_questions&.push(c.id)
        t.save
        c.save
      end

      quest_link = row[7]
      if quest_link.present?
        question_name = create_name(quest_link)
        w = Content.create(name: question_name, parent_id: t.parent_id, link: quest_link, data_type: 0)
        w.unique_id = "Q#{w.id}"
        w.difficulty = row[8].downcase
        w.priority = w.id
        w.question_type = 'assignment'
        t.video_questions&.push(w.id)
        t.save
        w.save
      end
    end
  end
  def create_name(link)
    name = link.split('https://leetcode.com/problems/')[1]
    name.gsub('/', '').gsub('-', ' ').titleize
  end
end

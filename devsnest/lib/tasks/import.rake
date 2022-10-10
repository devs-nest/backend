# frozen_string_literal: true

namespace :import_content do
  desc 'import contents from a csv file'
  require 'csv'
  task data: :environment do
    Content.destroy_all
    filename = File.join Rails.root, 'scripts/contents_sheet.csv'
    Content.create(unique_id: 'algo', parent_id: nil, name: 'Algorithms', data_type: 3, link: nil, priority: 0)
    # header remove

    CSV.foreach(filename, headers: true) do |row|
      topic = row[1]
      if topic.present?
        topic_slug = topic.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        t = Content.find_by(unique_id: topic_slug)
        t = Content.create(unique_id: topic_slug, parent_id: 'algo', name: topic, data_type: 4, link: nil) unless t.present?
      else
        t = Content.where(parent_id: 'algo', data_type: 4).last
      end

      quest_link = row[2]
      if quest_link.present?
        question_name = create_name(quest_link)
        c = Content.create(name: question_name, parent_id: t.unique_id, link: quest_link, data_type: 0)
        c.unique_id = "Q#{c.id}"
        c.difficulty = row[3].downcase
        c.priority = c.id
        c.question_type = 'class'
        c.save
      end

      quest_link = row[4]
      if quest_link.present?
        question_name = create_name(quest_link)
        w = Content.create(name: question_name, parent_id: t.unique_id, link: quest_link, data_type: 0)
        w.unique_id = "Q#{w.id}"
        w.difficulty = row[5].downcase
        w.priority = w.id
        w.question_type = 'assignment'
        w.save
      end
    end
  end

  def create_name(link)
    name = link.split('https://leetcode.com/problems/')[1]
    name.gsub('/', '').gsub('-', ' ').titleize
  end
end
# command to task  =>  rake import:data

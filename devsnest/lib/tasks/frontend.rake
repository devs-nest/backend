# frozen_string_literal: true

namespace :frontend do
  desc 'import frontend data from a csv file'
  require 'csv'
  task data: :environment do
    filename = File.join Rails.root, 'scripts/FrontendContent.csv'
    # header remove
    # Unique Id   Parent   Yname  Ylink  assignment name REF
    Content.create(unique_id: 'frontend', parent_id: nil, name: 'Frontend', data_type: 3, link: nil, priority: 0)
    CSV.foreach(filename, headers: true) do |row|
      topic = row[1]
      if topic.present?
        t = Content.find_by(unique_id: topic)
        t = Content.create(unique_id: topic, parent_id: 'frontend', name: topic, data_type: 4, link: nil) unless t.present?
      end

      link_id = row[0]
      if link_id.present?
        t = Content.create(unique_id: link_id, parent_id: row[1], name: row[2], data_type: 1, link: row[3])
        t.priority = t.id
        t.reference_data = JSON.parse(row[6]) if row[6].present?
        t.video_questions = []
        t.save
        puts('creating youtube link' + t.name)
        puts
      else
        t = Content.where(data_type: 1).last
      end

      quest_link = row[4]
      if quest_link.present?
        question_name = row[5]
        w = Content.create(name: question_name, parent_id: t.parent_id, link: quest_link, data_type: 0)
        w.unique_id = "Q#{w.id}"
        w.priority = w.id
        t.video_questions.push(w.id)
        w.question_type = 'assignment'
        w.save
        t.save
        puts('creating question' + w.name)
        puts
      end
    end
  end
end

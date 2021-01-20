# frozen_string_literal: true

namespace :import_content do
  desc 'import contents from a csv file'
  require 'csv'
  task data: :environment do
    filename = File.join Rails.root, 'scripts/data_content.csv'
    Content.create(unique_id: 'algo', parent_id: nil, name: 'Algorithms', data_type: 3, link: nil, priority: 0)
    CSV.foreach(filename) do |row|
      topic = row[0]
      topic_slug = topic.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
      t = Content.find_by(unique_id: topic_slug)
      t = Content.create(unique_id: topic_slug, parent_id: 'algo', name: topic, data_type: 4, link: nil, priority: 1) unless t.present?

      sub_topic = row[1]
      quest_link = row[2]
      c = Content.create(name: sub_topic, parent_id: t.unique_id, link: quest_link, data_type: 0, priority: 2)
      c.unique_id = "Q#{c.id}"
      c.save
    end
  end
end
# command to task  =>  rake import:data

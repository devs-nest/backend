# frozen_string_literal: true

bootcamps = %w[html css javascript]

bootcamps.each do |_bootcamp|
  (1..5).each do |_i|
    FrontendQuestion.create(question_markdown: 'random', active_path: '/index.html', open_paths: ['App.css', 'App.jsx'], show_explorer: true)
  end
end

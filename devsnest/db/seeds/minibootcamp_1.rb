# frozen_string_literal: true

bootcamps = %w[html css javascript]

bootcamps.each do |_bootcamp|
  (1..5).each do |_i|
    FrontendQuestion.create(
      question_markdown: 'Add h1 tag',
      template: 'vanilla',
      active_path: '/index.html',
      open_paths: ['/index.html'],
      show_explorer: true
    )
  end
end

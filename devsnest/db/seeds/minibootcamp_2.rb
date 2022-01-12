# frozen_string_literal: true

idn = FrontendQuestion.first&.id

Minibootcamp.create(unique_id: 'html', content_type: 0)

Minibootcamp.create(
  frontend_question_id: idn,
  unique_id: 'introduction',
  parent_id: 'html',
  name: 'Introduction',
  content_type: 1,
  markdown: 'html is the standard markup language for creating Web pages.',
  video_link: 'https://youtu.be/dQw4w9WgXcQ',
  image_url: 'https://dummyimage.com/600x400/000/fff',
  show_ide: true,
  current_lesson_number: 1
)

Minibootcamp.create(
  frontend_question_id: idn + 1,
  unique_id: 'elements',
  parent_id: 'html',
  name: 'Elements',
  content_type: 1,
  markdown: 'An html element is defined by a start tag, some content, and an end tag.',
  video_link: 'https://youtu.be/dQw4w9WgXcQ',
  image_url: 'https://dummyimage.com/600x400/000/fff',
  show_ide: true,
  current_lesson_number: 2
)

Minibootcamp.create(unique_id: 'css', content_type: 0)

Minibootcamp.create(
  frontend_question_id: idn + 2,
  unique_id: 'introduction',
  parent_id: 'css',
  name: 'Introduction',
  content_type: 1,
  markdown: 'css is the language we use to style a Web page.',
  video_link: 'https://youtu.be/dQw4w9WgXcQ',
  image_url: 'https://dummyimage.com/600x400/000/fff',
  show_ide: true,
  current_lesson_number: 1
)

Minibootcamp.create(
  frontend_question_id: idn + 3,
  unique_id: 'background',
  parent_id: 'css',
  name: 'Background',
  content_type: 1,
  markdown: 'The css background properties are used to add background effects for elements.',
  video_link: 'https://youtu.be/dQw4w9WgXcQ',
  image_url: 'https://dummyimage.com/600x400/000/fff',
  show_ide: true,
  current_lesson_number: 2
)

Minibootcamp.create(unique_id: 'javascript', content_type: 0)

Minibootcamp.create(
  frontend_question_id: idn + 4,
  unique_id: 'introduction',
  parent_id: 'javascript',
  name: 'Introduction',
  content_type: 1,
  markdown: 'JavaScript, often abbreviated JS, is a programming language.',
  video_link: 'https://youtu.be/dQw4w9WgXcQ',
  image_url: 'https://dummyimage.com/600x400/000/fff',
  show_ide: true,
  current_lesson_number: 1
)

Minibootcamp.create(
  frontend_question_id: idn + 5,
  unique_id: 'statements',
  parent_id: 'javascript',
  name: 'Statements',
  content_type: 1,
  markdown: 'JavaScript statements are composed of: Values, Operators, Expressions, Keywords, and Comments',
  video_link: 'https://youtu.be/dQw4w9WgXcQ',
  image_url: 'https://dummyimage.com/600x400/000/fff',
  show_ide: true,
  current_lesson_number: 2
)

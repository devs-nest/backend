# frozen_string_literal: true

idn = FrontendQuestion.first&.id

Minibootcamp.create(unique_id: 'html', content_type: 0)
Minibootcamp.create(frontend_question_id: idn, unique_id: 'introduction', parent_id: 'html', content_type: 1, markdown: 'html is the standard markup language for creating Web pages.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 1)
Minibootcamp.create(frontend_question_id: idn + 1, unique_id: 'elements', parent_id: 'html', content_type: 1, markdown: 'An html element is defined by a start tag, some content, and an end tag.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 2)
Minibootcamp.create(frontend_question_id: idn + 2, unique_id: 'attributes', parent_id: 'html', content_type: 1, markdown: 'html attributes provide additional information about html elements.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 3)
Minibootcamp.create(frontend_question_id: idn + 3, unique_id: 'headings', parent_id: 'html', content_type: 1, markdown: 'html headings are titles or subtitles that you want to display on a webpage.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 4)
Minibootcamp.create(frontend_question_id: idn + 4, unique_id: 'paragraphs', parent_id: 'html', content_type: 1, markdown: 'A paragraph always starts on a new line, and is usually a block of text.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 5)
Minibootcamp.create(unique_id: 'css', content_type: 0)
Minibootcamp.create(frontend_question_id: idn + 5, unique_id: 'introduction', parent_id: 'css', content_type: 1, markdown: 'css is the language we use to style a Web page.', video_link: 'https://youtu.be/dQw4w9WgXcQ',
                    image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 1)
Minibootcamp.create(frontend_question_id: idn + 6, unique_id: 'background', parent_id: 'css', content_type: 1, markdown: 'The css background properties are used to add background effects for elements.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 2)
Minibootcamp.create(frontend_question_id: idn + 7, unique_id: 'selectors', parent_id: 'css', content_type: 1, markdown: 'A css selector selects the html element(s) you want to style.', video_link: 'https://youtu.be/dQw4w9WgXcQ',
                    image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 3)
Minibootcamp.create(frontend_question_id: idn + 8, unique_id: 'borders', parent_id: 'css', content_type: 1, markdown: 'The css border properties allow you to specify the style, width, and color of an elements border.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 4)
Minibootcamp.create(frontend_question_id: idn + 9, unique_id: 'margin', parent_id: 'css', content_type: 1, markdown: 'Margins are used to create space around elements, outside of any defined borders.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 5)
Minibootcamp.create(unique_id: 'javascript', content_type: 0)
Minibootcamp.create(frontend_question_id: idn + 10, unique_id: 'introduction', parent_id: 'Javascript', content_type: 1, markdown: 'JavaScript, often abbreviated JS, is a programming language.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 1)
Minibootcamp.create(frontend_question_id: idn + 11, unique_id: 'statements', parent_id: 'Javascript', content_type: 1, markdown: 'JavaScript statements are composed of: Values, Operators, Expressions, Keywords, and Comments',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 2)
Minibootcamp.create(frontend_question_id: idn + 12, unique_id: 'variables', parent_id: 'Javascript', content_type: 1, markdown: 'You declare a JavaScript variable with the var keyword: var carName;.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 3)
Minibootcamp.create(frontend_question_id: idn + 13, unique_id: 'operators', parent_id: 'Javascript', content_type: 1, markdown: 'Assignment operators assign values to JavaScript variables',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 4)
Minibootcamp.create(frontend_question_id: idn + 14, unique_id: 'functions', parent_id: 'Javascript', content_type: 1, markdown: 'A JavaScript function is a block of code designed to perform a particular task.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 5)

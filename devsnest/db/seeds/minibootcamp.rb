# frozen_stri

Minibootcamp.create(unique_id: 'bootcamp')
Minibootcamp.create(unique_id: 'HTML', parent_id: 'bootcamp', content_type: 0)
Minibootcamp.create(unique_id: 'Introduction', parent_id: 'HTML', content_type: 1, markdown: 'HTML is the standard markup language for creating Web pages.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 1)
Minibootcamp.create(unique_id: 'Elements', parent_id: 'HTML', content_type: 1, markdown: 'An HTML element is defined by a start tag, some content, and an end tag.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 2)
Minibootcamp.create(unique_id: 'Attributes', parent_id: 'HTML', content_type: 1, markdown: 'HTML attributes provide additional information about HTML elements.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 3)
Minibootcamp.create(unique_id: 'Headings', parent_id: 'HTML', content_type: 1, markdown: 'HTML headings are titles or subtitles that you want to display on a webpage.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 4)
Minibootcamp.create(unique_id: 'Paragraphs', parent_id: 'HTML', content_type: 1, markdown: 'A paragraph always starts on a new line, and is usually a block of text.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 5)
Minibootcamp.create(unique_id: 'CSS', parent_id: 'bootcamp', content_type: 0)
Minibootcamp.create(unique_id: 'Introduction', parent_id: 'CSS', content_type: 1, markdown: 'CSS is the language we use to style a Web page.', video_link: 'https://youtu.be/dQw4w9WgXcQ',
                    image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 1)
Minibootcamp.create(unique_id: 'Background', parent_id: 'CSS', content_type: 1, markdown: 'The CSS background properties are used to add background effects for elements.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 2)
Minibootcamp.create(unique_id: 'Selectors', parent_id: 'CSS', content_type: 1, markdown: 'A CSS selector selects the HTML element(s) you want to style.', video_link: 'https://youtu.be/dQw4w9WgXcQ',
                    image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 3)
Minibootcamp.create(unique_id: 'Borders', parent_id: 'CSS', content_type: 1, markdown: 'The CSS border properties allow you to specify the style, width, and color of an elements border.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 4)
Minibootcamp.create(unique_id: 'Margin', parent_id: 'CSS', content_type: 1, markdown: 'Margins are used to create space around elements, outside of any defined borders.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff', current_lesson_number: 5)
Minibootcamp.create(unique_id: 'Javascript', parent_id: 'bootcamp', content_type: 0)
Minibootcamp.create(unique_id: 'Introduction', parent_id: 'Javascript', content_type: 1, markdown: 'JavaScript, often abbreviated JS, is a programming language.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff')
Minibootcamp.create(unique_id: 'Statements', parent_id: 'Javascript', content_type: 1, markdown: 'JavaScript statements are composed of: Values, Operators, Expressions, Keywords, and Comments',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff')
Minibootcamp.create(unique_id: 'Variables', parent_id: 'Javascript', content_type: 1, markdown: 'You declare a JavaScript variable with the var keyword: var carName;.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff')
Minibootcamp.create(unique_id: 'Operators', parent_id: 'Javascript', content_type: 1, markdown: 'Assignment operators assign values to JavaScript variables',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff')
Minibootcamp.create(unique_id: 'Functions', parent_id: 'Javascript', content_type: 1, markdown: 'A JavaScript function is a block of code designed to perform a particular task.',
                    video_link: 'https://youtu.be/dQw4w9WgXcQ', image_url: 'https://dummyimage.com/600x400/000/fff')

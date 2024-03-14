# frozen_string_literal: true

module Api
  module V1
    class CourseCurriculumResource < JSONAPI::Resource
      attributes :topic, :course_id, :course_type, :day, :video_link, :resources, :locked, :course_module_id
      attributes :assignment_questions, :contents

      filter :course_name, apply: lambda { |records, value, _options|
        course = Course.find_by(name: value[0])
        records.where(course_id: course&.id)
      }
      filter :course_type
      filter :day
      filter :course_module_id

      def assignment_questions
        if @model.course_module.granularity_type != 'question'
          @model.user_assignment_data(context[:user])
        else
          []
        end
      end

      def contents
        return [] if @model.course_module.granularity_type != 'question'

        user_assignment_data = @model.user_assignment_data(context[:user])
        user_article_data = @model.user_article_data(context[:user])
        data = []
        @model.contents.each do |content|
          data << if content['type'] == 'question'
                    {
                      'type': content['type'],
                      details: user_assignment_data.select { |assignment| assignment if assignment[:id] == content['id'] }.first
                    }
                  else
                    {
                      'type': content['type'],
                      'details': user_article_data.select { |article| article if article[:id] == content['id'] }.first
                    }
                  end
        end
        data
      end
    end
  end
end

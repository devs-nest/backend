# frozen_string_literal: true

class Counter
  def self.calculate_percent_complete(completed_question, total_question)
    completed_question.to_f / total_question * 100
  end
end

class Counter
	def self.calculate_percent_complete(completed_question, total_question)
		completed_question.to_f / total_question.to_f * 100
	end 
end

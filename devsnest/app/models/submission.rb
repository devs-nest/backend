# frozen_string_literal: true

class Submission < ApplicationRecord
  enum status: %i[done notdone doubt]

	 def self.create_submission(user_id, content_id, choice)
	 	byebug
	  # discord_id = params['data']['attributes']['discord_id']
	  # question_unique_id = params['data']['attributes']['question_unique_id']
	  # user = User.find_by(discord_id: discord_id)
	  # content = Content.find_by(unique_id: question_unique_id)
	  submission = Submission.find_by(user_id: user_id, content_id: content_id)
	  #user = User.find_by(discord_id: user_id)
	  
	  unless submission.present?
	    Submission.create(user_id: user.id, content_id: content.id, status: choice)
	    user.score += 10 if choice == 0
	    user.save
	    return 
	  end
	  
	  if submission.status.done? and choice != 0
	    user.score -= 10
	  elsif !submission.status.done? and choice == 0
	    user.score += 10
	  end
	  submission.status = choice
	  submission.save
	  user.save
	end

end

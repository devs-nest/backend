
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
	user = User.find_for_google_oauth2(request.env['omniauth.auth'],current_user)
	if user.persisted?
		if user.discord_id == ""
			byebug
			user = User.update_discord_id(user.uid)
			#redirect to user registration update page and get for put request
		else
			#redirect_to sign_in
			render json:user
		end

	else
		render "There was an error while trying to authenticate you..."
	end
	end
end
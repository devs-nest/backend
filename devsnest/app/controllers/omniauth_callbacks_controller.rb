
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
	user = User.find_for_google_oauth2(request.env['omniauth.auth'],current_user)
	if user.persisted?
		render json: user
	else
		render "There was an error while trying to authenticate you..."
	end
	end
end
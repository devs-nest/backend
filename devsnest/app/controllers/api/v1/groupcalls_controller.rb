# class Api::V1::GroupcallsController < ApplicationController

# end

module Api
    module V1
        class GroupcallsController < ApplicationController
            include JSONAPI::ActsAsResourceController
            # before_action :authenticate_user!
            # before_action :authorize, only: %i[update delete create]
    
            def show
                @user_choice = Groupcall.where(:choice => "yes")
                render json: @user_choice
                ##recheck
            end


            def create

                discord_id = params["data"]["attributes"]["discord_id"]
                user = User.find_by(discord_id: discord_id)
                return render_error('User not found') if user.nil?#render_error


                meeting = Groupcall.find_or_create_by(user_id: user.id)
                meeting.choice = params["data"]["attributes"]["choice"]
                meeting.save

                # render_success(meeting.as_json.merge("type":"groupcalls"))


                # render_success(meeting.as_json) #meeting.as_json.merge("type": "groupcalls"))
            end

        end
    end
end
  
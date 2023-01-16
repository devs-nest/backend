module Api
  module V1
    class UserIntegrationController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include LeetcodeHelper
      before_action :user_auth, except: %i[leetcode gfg hackerrank]

      def context
        { user: @current_user }
      end

      def links
        user = user = @current_user
        user_integration = user.user_integration

        api_render(200, user_integration&.as_json)
      end

      def update_links
        user = @current_user
        user_integration = user.user_integration

        user_integration = UserIntegration.create(user_id: user.id) if user_integration.blank?

        update_fields = params.dig(:data, :attributes).permit!

        user_integration.update(update_fields)

        render_success(message: "Integrations updated")
      end

      def leetcode
        username = params[:username]
        user = User.find_by(username: username)

        return render_error(message: "Invalid username") if user.blank?
        return render_error(message: "Leetcode not yet integrated") if user.user_integration.blank? || user.user_integration.leetcode_user_name.blank?

        leetcode_username = user.user_integration.leetcode_user_name
        leetcode_instance = LeetcodeHelper::LeetUser.new(leetcode_username)

        profile = leetcode_instance.prepare_results

        render_success(profile)
      end

      def gfg
        username = params[:username]
        user = User.find_by(username: username)

        return render_error(message: "Invalid username") if user.blank?
        return render_error(message: "GFG not yet integrated") if user.user_integration.blank? || user.user_integration.gfg_user_name.blank?

        gfg_usename = user.user_integration.gfg_user_name
        gfg_instance = GfgHelper::GfgUser.new(gfg_usename)

        profile = gfg_instance.data

        render_success(profile)
      end

      def hackerrank
        username = params[:username]
        user = User.find_by(username: username)

        return render_error(message: "Invalid username") if user.blank?
        return render_error(message: "HackerRank not yet integrated") if user.user_integration.blank? || user.user_integration.hackerrank_user_name.blank?

        hackerrank_user = user.user_integration.hackerrank_user_name
        hackerrank_instance = HackerrankHelper::HackerrankUser.new(hackerrank_user)

        profile = hackerrank_instance.profile.merge!({heatmap: hackerrank_instance.heatmap})

        render_success(profile)
      end
    end
  end
end

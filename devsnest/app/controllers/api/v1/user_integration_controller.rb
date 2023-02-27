module Api
  module V1
    class UserIntegrationController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include LeetcodeHelper
      before_action :user_auth, except: %i[leetcode gfg hackerrank github_data]
      before_action :set_user_and_integration, except: %i[links update_links]

      def context
        { user: @current_user }
      end

      def set_user_and_integration
        username = params[:username]
        @user = User.find_by(username: username)
        
        return render_error(message: "Invalid username") if @user.blank?
        @user_integration = @user.user_integration
        @cache = @user_integration.cache
      end

      def links
        user = @current_user
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
        return render_error(message: "Leetcode not yet integrated") if @user_integration.blank? || @user_integration.leetcode_user_name.blank?
        
        if @cache&.leetcode_cache.present?
          raw_data = JSON.parse(Base64.decode64(@cache.leetcode_cache))
          if Date.today < Date.parse(raw_data["valid_till"])
            return render_success(raw_data["metadata"])
          end
        end

        leetcode_username = @user_integration.leetcode_user_name
        leetcode_instance = LeetcodeHelper::LeetUser.new(leetcode_username)

        profile = leetcode_instance.prepare_results
        @user_integration.set_cache(profile, 'leetcode_cache') # TODO: delegate to sidekiq

        render_success(profile)
      end

      def gfg
        return render_error(message: "GFG not yet integrated") if @user_integration.blank? || @user_integration.gfg_user_name.blank?

        if @cache&.gfg_cache.present?
          raw_data = JSON.parse(Base64.decode64(@cache.gfg_cache))
          if Date.today < Date.parse(raw_data["valid_till"])
            return render_success(raw_data["metadata"])
          end
        end

        gfg_usename = @user.user_integration.gfg_user_name
        gfg_instance = GfgHelper::GfgUser.new(gfg_usename)

        profile = gfg_instance.data
        @user_integration.set_cache(profile, 'gfg_cache') # TODO: delegate to sidekiq

        render_success(profile)
      end

      def hackerrank
        return render_error(message: "HackerRank not yet integrated") if @user_integration.blank? || @user_integration.hackerrank_user_name.blank?

        if @cache&.hackerrank_cache.present?
          raw_data = JSON.parse(Base64.decode64(@cache.hackerrank_cache))
          if Date.today < Date.parse(raw_data["valid_till"])
            return render_success(raw_data["metadata"])
          end
        end

        hackerrank_user = @user_integration.hackerrank_user_name
        hackerrank_instance = HackerrankHelper::HackerrankUser.new(hackerrank_user)

        profile = {
          profile: hackerrank_instance.profile,
          heatmap: hackerrank_instance.heatmap,
          certificates: hackerrank_instance.certificates["data"],
          badges: hackerrank_instance.badges["models"]
        }
        @user_integration.set_cache(profile, 'hackerrank_cache') # TODO: delegate to sidekiq

        render_success(profile)
      end

      def github_data
        return render_error(message: "GitHub not yet integrated") if @user.github_client.blank?

        if @cache&.github_cache.present?
          raw_data = JSON.parse(Base64.decode64(@cache.github_cache))
          if Date.today < Date.parse(raw_data["valid_till"])
            return render_success(raw_data["metadata"])
          end
        end

        token = $cryptor.decrypt_and_verify(@user.github_token).dig(:access_token)
        github_instance = GithubDataHelper::GitHubData.new(@user.github_client.login, token)

        data = {
          github_graph: github_instance.get_github_graph,
          github_profile: github_instance.get_github_profile,
          # github_repository_data: GithubDataHelper.get_repository_data(user.github_client.login, user.github_repos)
        }
        @user_integration.set_cache(data, 'github_cache') # TODO: delegate to sidekiq
        render_success(data)
      end
    end
  end
end

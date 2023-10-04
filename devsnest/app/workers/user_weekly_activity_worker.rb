# frozen_string_literal: true

# worker sends mail to user weekly
class UserWeeklyActivityWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform 
    template_id = EmailTemplate.find_by(name: 'weekly_report_lm')&.template_id
    unsub_user_ids = Unsubscribe.get_by_cache
    User.where.not(id: unsub_user_ids).where(web_active: true).each do |user|
      dashboard_data = user.get_dashboard_by_cache

      EmailSenderWorker.perform_async(user.email, {
                                        'unsubscribe_token': user.unsubscribe_token,
                                        'username': user.username,
                                        'dsa_rank': dashboard_data[:leaderboard_details][:rank],
                                        'dsa_solved': dashboard_data[:dsa_solved].values.sum,
                                        'total_dsa': dashboard_data[:dsa_solved_by_difficulty].values.sum,
                                        'frontend_rank': dashboard_data[:fe_leaderboard_details][:rank],
                                        'frontend_solved': dashboard_data[:fe_solved].values.sum,
                                        'total_frontend': dashboard_data[:fe_solved_by_topic].values.sum,
                                        'mass_emailer': true
                                      }, template_id)
    end
  end
end

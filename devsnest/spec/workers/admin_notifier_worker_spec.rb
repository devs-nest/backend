require 'rails_helper'
RSpec.describe AdminNotifierWorker, type: :worker do
  let!(:bot) { create(:notification_bot) }
  let!(:user) { create(:user, user_type: 1, bot_id: bot.id, discord_active: true) }
  it 'Should send message with admin notifier worker' do
    user.update(bot_id: bot.id)
    AdminNotifierWorker.new.perform('Hello World')
  end
end

# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_update :expire_cache

  def self.get_by_cache(id)
    key = "#{name.downcase}_#{id}"

    Rails.cache.fetch(key, expires_in: 1.day) do
      find_by(id: id)
    end
  end

  def expire_cache
    Rails.cache.delete("#{self.class.name.downcase}_#{id}")
  end
end

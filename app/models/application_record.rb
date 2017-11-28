class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_create :invalidate_count_cache
  before_destroy :invalidate_count_cache

  def self.cached_count
    Rails.cache.fetch("#{ancestors.first.name}/count", expires_in: 120.minutes) do
      "#{ancestors.first.name}".constantize.count
    end
  end

  def invalidate_count_cache
    Rails.cache.delete("#{self.class.name}/count")
  end

end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_create :invalidate_count_cache
  after_destroy :invalidate_count_cache

  def self.count
    Rails.cache.fetch("#{ancestors.first.name}/count", expires_in: 120.minutes) do
      super
    end
  end

  def invalidate_count_cache
    Rails.cache.delete("#{self.class.name}/count")
  end

end

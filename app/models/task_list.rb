class TaskList < ApplicationRecord
  extend FriendlyId
  validates :name, presence: true

  friendly_id :name, use: :slugged
  validates :slug, uniqueness: true
  has_many :tasks, dependent: :destroy
  
  def last_general_update_at
    [updated_at].concat(tasks.collect { |x| x.updated_at }).max
  end
end
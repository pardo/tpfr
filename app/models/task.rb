class Task < ApplicationRecord
    belongs_to :task_list
    validates :type, presence: true, inclusion: { in: %w(TODOTask TemporalTask ProgressTask) }
    validates :priority, presence: true
    validates :description, presence: true, length: { maximum: 255 }

    def <=> (other)
        self.priority <=> other.priority
    end

end
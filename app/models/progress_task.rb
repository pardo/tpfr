class ProgressTask < Task
  def state
    case progress_state
      when 1..99
        "in_progress"
      when 100
        "done"
      else
        "not_done"
    end 
  end
  
  validates :state, inclusion: { in: %w(done not_done in_progress) }
  validates :progress_state, presence: true, inclusion: { in: 0..100, message: "Must be a number between 0 and 100" }
  validates :start_date, :end_date, absence: true
end
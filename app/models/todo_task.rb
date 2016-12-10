class TODOTask < Task
  validates :state, inclusion: { in: %w(done not_done) }
  validates :start_date, :end_date, :progress_state, absence: true
end
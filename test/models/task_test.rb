require 'test_helper'

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "task sorting by priority" do
    TaskList.create(name: "test")
    tl = TaskList.first
    # 0 means high priority
    TODOTask.create!({ priority: 6, state: "not_done", description: ".", task_list_id: tl.id })
    TemporalTask.create!({ priority: 4, state: "not_done", description: ".", start_date: Date.today - 1, end_date: Date.today + 10, task_list_id: tl.id })
    ProgressTask.create!({ priority: 1, description: ".", progress_state: 60, task_list_id: tl.id })
    TODOTask.create!({ priority: 5, state: "done", description: ".", task_list_id: tl.id })
    TemporalTask.create!({ priority: 3, state: "expired", description: ".", start_date: Date.today - 10, end_date: Date.today - 2, task_list_id: tl.id })
    ProgressTask.create!({ priority: 0, description: ".", progress_state: 100, task_list_id: tl.id})
    ProgressTask.create!({ priority: 2, description: ".", progress_state: 0, task_list_id: tl.id })

    # not changes on sorting , same order defined by id
    priorities = Task.all.collect { |x| x.priority }
    assert priorities == [6,4,1,5,3,0,2]

    #sorted by priority
    priorities = Task.all.sort.collect { |x| x.priority }
    assert priorities == (0..6).to_a
  end
end
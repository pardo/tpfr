require 'test_helper'

class TaskControllerTest < ActionDispatch::IntegrationTest
  test "without parameter a task shouldn't be created" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test"
    assert Task.count.zero?
  end

  test "without parameter a task shouldnt be created" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test"
    assert Task.count.zero?
  end

  test "with missing parameters shouldnt be created" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test",
      params: { description: "description", type: "TODOTask", state: "not_done" }
    assert Task.count.zero?
  end

  test "with correct parameters a task should be created TODOTask" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test",
      params: { description: "description", type: "TODOTask", state: "not_done", priority: 0 }
    assert Task.count == 1
  end

  test "with correct parameters a task should be created ProgressTask" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test",
      params: { description: "description", type: "ProgressTask", progress_state: 0, priority: 0 }
    assert Task.count == 1
  end


  test "with out of bounds progress ProgressTask shouldnt be changed" do
    TaskList.create(name: "test")
    ProgressTask.create({
      priority: 4,
      description: ".",
      progress_state: 0,
      task_list_id: TaskList.first.id    
    })
    assert ProgressTask.first.progress_state.zero?
    
    put url_for controller: "task", action: "update", slug: "test", id: ProgressTask.first.id, params: { progress_state: 1, type: "ProgressTask"}
    assert ProgressTask.first.progress_state == 1

    put url_for controller: "task", action: "update", slug: "test", id: ProgressTask.first.id, params: { progress_state: -1, type: "ProgressTask"}
    assert ProgressTask.first.progress_state == 1

    put url_for controller: "task", action: "update", slug: "test", id: ProgressTask.first.id, params: { progress_state: 101, type: "ProgressTask"}
    assert ProgressTask.first.progress_state == 1

  end

  test "with correct parameters a task should be created TemporalTask" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test",
      params: { description: "description", type: "TemporalTask", start_date: "2016-01-01", end_date: "2016-01-02", state: "not_done", priority: 0 }
    assert Task.count == 1
  end

  test "TemporalTask shouldnt allow inverted date range" do
    TaskList.create(name: "test")
    post url_for controller: "task", action: "create", slug: "test",
      params: { description: "description", type: "TemporalTask", start_date: "2016-01-01", end_date: "2015-01-02", state: "not_done", priority: 0 }
    assert Task.count.zero?
  end
end

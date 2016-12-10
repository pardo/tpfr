require 'test_helper'

class TasklistControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get url_for controller: "tasklist", action: "home"
    assert_response :success   
  end

  test "should not create a new tasklist and return 400" do
    post url_for controller: "tasklist", action: "create"
    assert_response 400
    assert TaskList.count.zero?
  end

  test "should create a new tasklist" do
    post url_for controller: "tasklist", action: "create", params: { name: "Name" }
    assert_response :redirect
    assert TaskList.count == 1
  end

  test "should create 2 tasklist even if the name is the same" do
    post url_for controller: "tasklist", action: "create", params: { name: "Name" }
    assert_response :redirect
    assert TaskList.count == 1
    post url_for controller: "tasklist", action: "create", params: { name: "Name" }
    assert_response :redirect
    assert TaskList.count == 2    
  end

  test "TemporalTask should expire when printed on the main list" do
    TaskList.create(name: "test")
    TemporalTask.create({
      priority: 4,
      state: "not_done",
      description: "Temporal task that is expired but didn't change yet",
      start_date: Date.today - 10,
      end_date: Date.today - 2,
      task_list_id: TaskList.first.id    
    })

    assert TemporalTask.first.state == "not_done"
    get url_for controller: "tasklist", action: "show", slug: "test"
    assert_response :success
    assert TemporalTask.first.state == "expired"
  end
end

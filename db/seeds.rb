# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tl = TaskList.create({
    name: 'Lista 0',
})

TODOTask.create({
    priority: 1,
    state: "not_done",
    description: "Todo task initialized with not done",
    task_list_id: tl.id
})

TODOTask.create({
    priority: 2,
    state: "done",
    description: "Todo task marked as completed",
    task_list_id: tl.id
})

TemporalTask.create({
    priority: 3,
    state: "not_done",
    description: "Temporal task that started yesterday and ends in 10 days",
    start_date: Date.today - 1,
    end_date: Date.today + 10,
    task_list_id: tl.id    
})

TemporalTask.create({
    priority: 4,
    state: "expired",
    description: "Temporal task that is expired by time being",
    start_date: Date.today - 10,
    end_date: Date.today - 2,
    task_list_id: tl.id    
})

ProgressTask.create!({
    priority: 1,
    description: "Progress task that is just created so it starts with 0",
    progress_state: 0,
    task_list_id: tl.id    
})

ProgressTask.create!({
    priority: 1,
    description: "Progress task that has over 50% of it completed",
    progress_state: 60,
    task_list_id: tl.id    
})

ProgressTask.create!({
    priority: 1,
    description: "Progress task that is 100% complete",
    progress_state: 100,
    task_list_id: tl.id
})

class TaskController < ApplicationController
    before_action :get_task_list, only: [:create, :update]

    def create
        @task = Task.new(task_params)
        @task.task_list = @task_list
        if @task.save
            flash[:notice] = "Successfully created"
            redirect_to controller: "tasklist", action: "show", slug: params[:slug]
        else
            flash[:error] = @task.errors
            redirect_to controller: "tasklist", action: "show", slug: params[:slug]
        end
    end

    def update
        @task = @task_list.tasks.find(params[:id])
        if @task.update(task_params)
            render json: @task
        else
            render json: @task.errors, status: 400            
        end
    end

    private
        def get_task_list
            @task_list = TaskList.find_by!(slug: params[:slug])
        end

        def task_params
            case params[:type]
                when "ProgressTask"
                    params.permit(:description, :priority, :progress_state, :type)
                when "TODOTask"
                    params.permit(:description, :state, :priority, :type)                    
                when "TemporalTask"
                    params.permit(:description, :state, :priority, :start_date, :end_date, :type)
                else
                    params.permit(:type)
            end
        end
end

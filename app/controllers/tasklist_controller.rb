class TasklistController < ApplicationController
    before_action :get_task_list, only: [:show, :update]

    def home
        task_list_ids = session[:task_list_ids] || []
        @task_list_list = TaskList.where(id: task_list_ids.last(5))
    end

    def create
        @task_list = TaskList.new(params.permit(:name))
        if @task_list.save
            task_list_ids = session[:task_list_ids] || []
            task_list_ids << @task_list.id
            session[:task_list_ids] = task_list_ids
            redirect_to controller: "tasklist", action: "show", slug: @task_list.slug
        else
            @task_list_list = TaskList.all
            render :home, status: 400
        end
    end

    def show
        @tasks = @task_list.tasks.order(:priority)
    end

    def update
        if @task_list.update(params.permit(:name))
            render json: @task_list
        else
            render json: @task_list.errors, status: 400
        end
    end

    private
        def get_task_list
            @task_list = TaskList.find_by!(slug: params[:slug])
        end

end

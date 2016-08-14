class TasksController < ApplicationController

  def index
    @pinned = sort_tasks(Task.where(pinned: true))
    @unpinned = sort_tasks(Task.where(pinned:nil))

    save_sort_preference
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "New task created."
      redirect_to @task
    else
      flash.now[:error] = "Oops!"
      render new_task_path
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:success] = "Boom!"
    else
      flash[:error] = "Er...."
    end
      redirect_to root_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:success] = "You updated the task."
      if params[:task][:pinned] || params[:task][:completed]
        redirect_to root_path
      else
        redirect_to @task
      end
    else
      flash.now[:error] = "Try again."
      render :edit
    end
  end

  private

  def task_params
    params.require(:task).permit(:description, :due_date, :priority, :category, :pinned, :completed)
  end

  def sort_tasks(tasks)
    sort = params['sort'] || session['sort'] || "ASC"
    if sort == "priority"
      tasks = tasks.order("priority ASC")
    elsif sort == "category"
      tasks = tasks.order("category ASC")
    else
      tasks = tasks.order("due_date #{sort.upcase}")
    end
    tasks
  end

  def save_sort_preference
    session['sort'] = params['sort']
  end
end

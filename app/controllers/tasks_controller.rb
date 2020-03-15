class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy,:edit,:show]
    def index
      #session[:user_id] = nil
      if logged_in?
        @task = current_user.tasks.build  # form_with 用
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
        #@tasks = Task.all
      end
    end
    def show
    @task = Task.find(params[:id])
    end
    def new
    @task = Task.new
    end
    def create
    @task = current_user.tasks.build(task_params)
      if @task.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
      else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'tasks/index'
      end
    end
    def edit  
      @task = Task.find(params[:id])
    end
    def update
      @task = Task.find(params[:id])
        if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
        else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
        end
    end
    def destroy
    @task.destroy
    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
    end
   
     private
     
  def set_message
    @task = Task.find(params[:id])
  end
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  
end
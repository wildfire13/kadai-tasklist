class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_user
    @task = current_user.tasks.build
    @tasks = current_user.tasks.order("created_at DESC").page(params[:page]).per(10)
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
      flash[:success] = "正常に登録されました。"
      redirect_to root_url
    else 
      flash.now[:danger] = "登録できませんでした。"
      render :new
    end
  end


  def edit
  end


  def update
    if @task.update(task_params)
      flash[:success] = "正常に変更されました。"
      redirect_to @task
    else
      flash.now[:danger] = "変更できませんでした。"
      render :edit
    end
  end


  def destroy
    @task.destroy
    flash[:success] = "正常に削除されました。"
    redirect_back(fallback_location: root_path)
  end


  private


  def set_task
      @task = Task.find(params[:id])
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_path
    end
  end
end

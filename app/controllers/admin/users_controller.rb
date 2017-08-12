class Admin::UsersController < ApplicationController
  before_action :fetch_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = User.generate_random_password

    if @user.save
      redirect_to admin_users_path, flash: { notice: 'Successfully created user' }
    else
      flash.now[:alert] = @user.errors.full_messages.join(" ")
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, flash: { notice: 'Successfully updated user' }
    else
      flash.now[:alert] = @user.errors.full_messages.join(" ")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, flash: { notice: 'Successfully deleted user' }
    else
      redirect_to admin_users_path, flash: { alert: @user.errors.full_messages.join(" ") }
    end
  end
  private

  def fetch_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end

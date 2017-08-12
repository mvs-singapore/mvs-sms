class Admin::UsersController < ApplicationController
  def index
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
      flash.now[:error] = @user.errors.full_messages.join(" ")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end

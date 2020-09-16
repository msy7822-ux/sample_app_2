class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end 
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # 保存処理が成功したときの処理をここに記述
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      # コントローラーを経由することなくそのままnew.html.erbのビューファイルを表示する
      render 'new'
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

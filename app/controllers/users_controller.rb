class UsersController < ApplicationController
  
  #GET /users/:id
  def show
    @user = User.find(params[:id])
  end
  
  #GET /users/new
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      #サインアップしたらついでにlog_in する
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #redirect_toとは
      # GET "/users.#{@user.id}"  
      #に対しGETリクエストを飛ばすということ
      #詳細に分解すると
      #redirect_to user_path(@user)
      #-> redirect_to user_path(@user.id)
          #-> redirect_to user_path(1)
             #->              /users/1
             #となる 
    else
      render 'new'
      #失敗した場合、もう一度newテンプレートに遷移する
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
